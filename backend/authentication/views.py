from .models import User, CallBackToken
from random import randint
from django.core.mail import send_mail
from django.conf import settings
from django.core.exceptions import ValidationError
from django.core.validators import validate_email
from rest_framework.decorators import api_view, permission_classes
from rest_framework.response import Response
from rest_framework.authtoken.models import Token
import json
from google.oauth2 import id_token
from google.auth.transport import requests


def getUserLoginDetailJSON(email):
    jsonData  = {}
    if User.objects.filter(email=email).exists():
        user = User.objects.get(email=email)
        token = Token.objects.get(
        user=user).key
        tokenDict = {'token': token,
                    'NewUser': 'false',
                    "username": user.username,
                    "firstname": user.first_name,
                    "lastname": user.last_name,
                    "profilepiclink": user.profile_pic_link,
                    "description": user.description,
                    "about": user.about,
                    }
        jsonData = json.dumps(tokenDict)
        if CallBackToken.objects.filter(email=email).exists():
            CallBackToken.objects.get(email=email).delete()        
    else:
        tokenDict = {'token': '', 'NewUser': 'true'}
        jsonData = json.dumps(tokenDict)
    return jsonData


# this validates the email and sent the callbacktoken to the email
@api_view(['POST'])
def validateEmail(request):
    # isUserNew = User.objects.filter(email=email).exists()
    email = request.data["email"]
    # email = request.headers.get('email')
    try:
        validate_email(email)
    except ValidationError as e:
        print("bad email, details:", e)
        return Response(data='Invalid email', status=400)
    # else:
    #     print("good email")

    callbacktoken = randint(100000, 999999)
    if CallBackToken.objects.filter(email=email).exists():
        token = CallBackToken.objects.get(email=email)
        token.callBackToken = callbacktoken
        token.save()
    else:
        CallBackToken(email=email, callBackToken=callbacktoken).save()
    subject = 'Opinion - OTP for login'
    message = 'Your OTP to login is {}'.format(callbacktoken)
    # email_from = 'Opinion@noreply.com'
    email_from = settings.EMAIL_HOST_USER
    recipient_list = [email]
    send_mail(subject, message, email_from, recipient_list)
    return Response(data='OTP has been sent to the email address', status=200)


@api_view(['POST'])
def submitCallBackToken(request):
    # callbacktoken = int(request.headers.get('callbacktoken'))
    # email = request.headers.get('email')
    callbacktoken = int(request.data['callbacktoken'])
    email = request.data['email']

    if email != None and callbacktoken != None:
        if CallBackToken.objects.filter(email=email).exists():
            if CallBackToken.objects.get(email=email).callBackToken == callbacktoken:
                jsonData = getUserLoginDetailJSON(email)
                return Response(data=jsonData, status=200)
            else:
                return Response(data='Incorrect email and callbacktoken combination', status=400)
        else:
            return Response(data='No token exists for the given email', status=400)
    else:
        return Response(data='Incorrect email and callbacktoken combination', status=400)


@api_view(['POST'])
def createUser(request):
    username = request.data['username']
    email = request.data['email']
    first_name = request.data['firstname']
    last_name = request.data['lastname']
    profile_pic_link = request.data['profilePicLink']
    callbacktoken = int(request.data['callbacktoken'])
    if CallBackToken.objects.get(email=email).callBackToken == callbacktoken:
        CallBackToken.objects.get(email=email).delete()
        User(username=username, email=email,
             first_name=first_name, last_name=last_name, profile_pic_link=profile_pic_link).save()
        token = Token.objects.get(
            user=User.objects.get(email=email)).key
        tokenDict = {'token': token}
        jsonData = json.dumps(tokenDict)
        return Response(data=jsonData, status=200)
    else:
        return Response(data='Incorrect email and callbacktoken combination', status=400)

@api_view(['POST'])
def googleSignIn(request):
    idToken = request.data['idToken']
    clientId = '963698245018-85an8b7nqm696d9j704519eei1lpv42f.apps.googleusercontent.com'
    # try:
    idinfo = id_token.verify_oauth2_token(idToken, requests.Request(), clientId)
    # except ValueError:
    #     print('Invalid ID Token for Google SignIn')
    #     return Response(status=404)
    email = idinfo['email']
    jsonData = getUserLoginDetailJSON(email)
    if not User.objects.filter(email=email).exists():
        callbacktoken = randint(100000, 999999)
        if CallBackToken.objects.filter(email=email).exists():
            token = CallBackToken.objects.get(email=email)
            token.callBackToken = callbacktoken
            token.save()
        else:
            CallBackToken(email=email, callBackToken=callbacktoken).save()
        jsonData = json.loads(jsonData)
        jsonData['email'] = email
        jsonData['callbacktoken'] = str(callbacktoken)
        jsonData = json.dumps(jsonData)
    # else:
    #     jsonData = json.loads(jsonData)
    #     jsonData['email'] = email
    #     jsonData['callbacktoken'] = idinfo['sub']
    #     jsonData = json.dumps(jsonData)
    return Response(data=jsonData, status=200)
        
            
    

        