from fcm_django.models import FCMDevice
from authentication.models import User
from users.models import UserRelationList
from django.core.paginator import Paginator
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.decorators import api_view, permission_classes
import json

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def follow(request):
    user = request.user
    chadUserId = request.data['userId']
    chadUser = User.objects.get(id=chadUserId)
    if chadUser == user:
        return Response(status=400)
    UserRelationList.objects.create(chadUser=chadUser, follower=user)
    return Response(status=200)


@api_view(['POST'])
@permission_classes([IsAuthenticated])
def unfollow(request):
    user = request.user
    loserUserId = request.data['userId']
    loserUser = User.objects.get(id=loserUserId)
    if loserUser == user:
        return Response(status=400)
    UserRelationList.objects.get(chadUser=loserUser, follower=user).delete()
    return Response(status=200)


@api_view(['POST'])
@permission_classes([IsAuthenticated])
def getFollowers(request):
    user = request.user
    paginationNumber = int(request.data['paginationNumber'])
    followersList = UserRelationList.objects.filter(
        chadUser=user).order_by('followingSince')
    paginator = Paginator(followersList, 20)
    data = paginator.get_page(paginationNumber)
    dataList = []
    for i in range(len(data)):
        followingUser = data[i].follower
        userDetail = {
            'id': str(followingUser.id),
            'username': followingUser.username,
            'fullname': followingUser.first_name + ' ' + followingUser.last_name,
            'profilePicLink': followingUser.profile_pic_link,
            # 'description': followingUser.description,
            # 'about': followingUser.about,
            'following': 'true' if UserRelationList.objects.filter(chadUser=followingUser, follower=request.user).exists() else "false",

        }
        dataList.append(userDetail)
    dataListJson = json.dumps(dataList)
    return Response(data=dataListJson, status=200)


@api_view(['POST'])
@permission_classes([IsAuthenticated])
def getFollowing(request):
    user = request.user
    paginationNumber = int(request.data['paginationNumber'])
    followingList = UserRelationList.objects.filter(
        follower=user).order_by('followingSince')
    paginator = Paginator(followingList, 20)
    data = paginator.get_page(paginationNumber)
    dataList = []
    for i in range(len(data)):
        chadUser = data[i].chadUser
        userDetail = {'id': str(chadUser.id),
                      'username': chadUser.username,
                      'fullname': chadUser.first_name + ' ' + chadUser.last_name,
                      'profilePicLink': chadUser.profile_pic_link,
                      #   'description': chadUser.description,
                      #   'about': chadUser.about,
                      'following': 'true'
                      }
        dataList.append(userDetail)
    dataListJson = json.dumps(dataList)
    return Response(data=dataListJson, status=200)


@api_view(['POST'])
@permission_classes([IsAuthenticated])
def searchUser(request):
    startsWith = request.data['startsWith']
    if startsWith == '':
        dataListJson = json.dumps([])
        return Response(data=dataListJson, status=200)
    paginationNumber = int(request.data['paginationNumber'])
    userList = User.objects.filter(
        username__startswith=startsWith).order_by('username')
    paginator = Paginator(userList, 20)
    data = paginator.get_page(paginationNumber)
    dataList = []
    for i in range(len(data)):
        user = data[i]
        if user == request.user:
            continue
        userDetail = {'id': str(user.id),
                      'username': user.username,
                      'fullname': user.first_name + ' ' + user.last_name,
                      'profilePicLink': user.profile_pic_link,
                      #   'description': user.description,
                      #   'about': user.about,

                      'following': 'true' if UserRelationList.objects.filter(chadUser=user, follower=request.user).exists() else "false",

                      }
        dataList.append(userDetail)
    dataListJson = json.dumps(dataList)
    return Response(data=dataListJson, status=200)


@api_view(['POST'])
@permission_classes([IsAuthenticated])
def getUserDetails(request):
    user = request.user
    requestedUserUsername = request.data['username']
    requestedUser = User.objects.get(username=requestedUserUsername)
    data = {
        'id': str(requestedUser.id),
        'fullname': requestedUser.first_name + ' ' + requestedUser.last_name,
        'profilePicLink': requestedUser.profile_pic_link,
        'description': requestedUser.description,
        'about': requestedUser.about,
        'following': 'true' if UserRelationList.objects.filter(chadUser=user, follower=requestedUser).exists() else "false",

    }
    dataJson = json.dumps(data)
    return Response(data=dataJson, status=200)


@api_view(['POST'])
@permission_classes([IsAuthenticated])
def updateUserDetails(request):
    user = request.user
    user.username = request.data['username']
    user.firstname = request.data['firstname']
    user.lastname = request.data['lastname']
    user.description = request.data['title']
    user.about = request.data['about']
    user.save()
    return Response(status=200)


@api_view(['POST'])
@permission_classes([IsAuthenticated])
def setDeviceToken(request):
    user = request.user 
    deviceToken = request.data['deviceToken']
    # user.deviceToken = deviceToken
    # user.save()
    if FCMDevice.objects.filter(registration_id  = deviceToken).exists():
        FCMDevice.objects.filter(registration_id  = deviceToken).delete()
    if FCMDevice.objects.filter(user = user).exists():
        FCMDevice.objects.filter(user = user).update(registration_id  = deviceToken)        
    else:
        FCMDevice.objects.create(registration_id  = deviceToken,type = 'android',user = user)        
    return Response(status=200)

