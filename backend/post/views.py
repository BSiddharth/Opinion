from users.models import UserRelationList
from authentication.models import User
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from .models import Comment, Post, ReplyComment, Vote
from django.core.paginator import Paginator
import json
from django.db.models import F
from firebase_admin.messaging import Message, Notification
from fcm_django.models import FCMDevice


@api_view(['POST'])
@permission_classes([IsAuthenticated])
def createPost(request):
    author = request.user
    imageUrl = request.data['imageUrl']
    title = request.data['title']
    section = request.data['section']
    description = request.data['description']
    votable = request.data['votable']
    option1text = request.data['option1text']
    option2text = request.data['option2text']
    option3text = request.data['option3text']
    option4text = request.data['option4text']
    Post.objects.create(
        author=author,
        imageUrl=imageUrl,
        title=title,
        section=section,
        description=description, votable=votable,
        option1text=option1text,
        option2text=option2text,
        option3text=option3text,
        option4text=option4text,
    )

    return Response(status=200)


@api_view(['POST'])
@permission_classes([IsAuthenticated])
def getPosts(request):
    username = request.data['username']
    user = request.user
    paginationNumber = int(request.data['paginationNumber'])
    author = User.objects.get(username=username)
    postsList = Post.objects.filter(
        author=author).order_by('posted_at').reverse()
    paginator = Paginator(postsList, 10)
    data = paginator.get_page(paginationNumber)
    dataList = []

    # jsonData = json.dumps(data)
    for i in range(len(data)):
        parentPost = data[i]
        optionChoosen = ''
        if Vote.objects.filter(parentPost=data[i], author=user).exists():
            # if data[i] in user.postParticipatedIn.all():
            optionChoosen = Vote.objects.get(
                parentPost=data[i], author=user).voteLabel
        option1votes = Vote.objects.filter(
            parentPost=parentPost, voteLabel='A').count()
        option2votes = Vote.objects.filter(
            parentPost=parentPost, voteLabel='B').count()
        option3votes = Vote.objects.filter(
            parentPost=parentPost, voteLabel='C').count()
        option4votes = Vote.objects.filter(
            parentPost=parentPost, voteLabel='D').count()
        post = {
            'id': str(data[i].id),
            'posted_at': data[i].posted_at.strftime('%Y-%m-%d %X %z'),
            'title': data[i].title,
            'imageUrl': data[i].imageUrl,
            'description': data[i].description,
            'section': data[i].section,
            'userProfileImage': data[i].author.profile_pic_link,
            'username': data[i].author.username,
            'votable': data[i].votable,
            'option1votes': option1votes,
            'option2votes': option2votes,
            'option3votes': option3votes,
            'option4votes': option4votes,
            'option1text': data[i].option1text,
            'option2text': data[i].option2text,
            'option3text': data[i].option3text,
            'option4text': data[i].option4text,
            'totalComments': data[i].totalComments,
            'bookmarked': 'true'if data[i] in request.user.bookmarks.all() else 'false',
            'optionChoosen': optionChoosen,
        }

        dataList.append(post)

    dataListJson = json.dumps(dataList)
    return Response(data=dataListJson, status=200)


@api_view(['POST'])
@permission_classes([IsAuthenticated])
def getParticipatedPosts(request):
    user = request.user
    paginationNumber = int(request.data['paginationNumber'])
    userParticapatedPostsList = user.vote_set.all().order_by('posted_at')
    # postsList = Post.objects.filter(vote_set.author= user ).order_by('posted_at').reverse()
    paginator = Paginator(userParticapatedPostsList, 10)
    # paginator = Paginator(postsList, 10)
    data = paginator.get_page(paginationNumber)
    dataList = []

    # jsonData = json.dumps(data)
    for i in range(len(data)):
        parentPost = data[i].parentPost
        optionChoosen = data[i].voteLabel
        author = parentPost.author
        option1votes = Vote.objects.filter(
            parentPost=parentPost, voteLabel='A').count()
        option2votes = Vote.objects.filter(
            parentPost=parentPost, voteLabel='B').count()
        option3votes = Vote.objects.filter(
            parentPost=parentPost, voteLabel='C').count()
        option4votes = Vote.objects.filter(
            parentPost=parentPost, voteLabel='D').count()
        post = {
            'id': str(parentPost.id),
            'posted_at': parentPost.posted_at.strftime('%Y-%m-%d %X %z'),
            'title': parentPost.title,
            'imageUrl': parentPost.imageUrl,
            'description': parentPost.description,
            'section': parentPost.section,
            'userProfileImage': author.profile_pic_link,
            'username': author.username,
            'votable': parentPost.votable,
            'option1votes': option1votes,
            'option2votes': option2votes,
            'option3votes': option3votes,
            'option4votes': option4votes,
            'option1text': parentPost.option1text,
            'option2text': parentPost.option2text,
            'option3text': parentPost.option3text,
            'option4text': parentPost.option4text,
            'totalComments': parentPost.totalComments,
            'bookmarked': 'true'if parentPost in user.bookmarks.all() else 'false',
            'optionChoosen': optionChoosen,
        }

        dataList.append(post)

    dataListJson = json.dumps(dataList)
    return Response(data=dataListJson, status=200)


@api_view(['POST'])
@permission_classes([IsAuthenticated])
def bookmarkPost(request):
    user = request.user
    postId = request.data['postId']
    post = Post.objects.get(id=postId)
    if request.data['action'] == 'add':

        user.bookmarks.add(post)
    else:
        user.bookmarks.remove(post)

    return Response(status=200)


@api_view(['POST'])
@permission_classes([IsAuthenticated])
def getBookmarks(request):
    user = request.user
    bookmarks = user.bookmarks.order_by('posted_at').reverse()
    paginator = Paginator(bookmarks, 10)
    paginationNumber = int(request.data['paginationNumber'])
    data = paginator.get_page(paginationNumber)
    dataList = []
    for i in range(len(data)):
        optionChoosen = ''
        if Vote.objects.filter(parentPost=data[i], author=user).exists():
            # if data[i] in user.postParticipatedIn.all():
            optionChoosen = Vote.objects.get(
                parentPost=data[i], author=user).voteLabel
        option1votes = Vote.objects.filter(
            parentPost=data[i], voteLabel='A').count()
        option2votes = Vote.objects.filter(
            parentPost=data[i], voteLabel='B').count()
        option3votes = Vote.objects.filter(
            parentPost=data[i], voteLabel='C').count()
        option4votes = Vote.objects.filter(
            parentPost=data[i], voteLabel='D').count()
        bookmark = {
            'id': str(data[i].id),
            'posted_at': data[i].posted_at.strftime('%Y-%m-%d %X %z'),
            'title': data[i].title,
            'imageUrl': data[i].imageUrl,
            'description': data[i].description,
            'section': data[i].section,
            'userProfileImage': data[i].author.profile_pic_link,
            'username': data[i].author.username,
            'votable': data[i].votable,
            'option1votes': option1votes,
            'option2votes': option2votes,
            'option3votes': option3votes,
            'option4votes': option4votes,
            'option1text': data[i].option1text,
            'option2text': data[i].option2text,
            'option3text': data[i].option3text,
            'option4text': data[i].option4text,
            'totalComments': data[i].totalComments,
            'optionChoosen': optionChoosen,
            'bookmarked': 'true'if data[i] in request.user.bookmarks.all() else 'false',
        }

        dataList.append(bookmark)

    dataListJson = json.dumps(dataList)
    return Response(data=dataListJson, status=200)


@api_view(['POST'])
@permission_classes([IsAuthenticated])
def createComment(request):
    author = request.user
    message = request.data['message']
    parentPostId = request.data['parentPostId']
    parentPost = Post.objects.get(id=parentPostId)
    Comment.objects.create(
        author=author,
        message=message,
        parentPost=parentPost,
    )
    parentPost.totalComments = F('totalComments')+1
    parentPost.save()
    recipient = parentPost.author
    sendNotif(title=f"{author.username} commented on your post",body=message,imageLink=author.profile_pic_link,recipient=recipient)

    return Response(status=200)


@api_view(['POST'])
@permission_classes([IsAuthenticated])
def getComments(request):
    postId = request.data['postId']
    post = Post.objects.get(id=postId)
    comments = post.comment_set.order_by('posted_at').reverse()
    paginator = Paginator(comments, 10)
    paginationNumber = int(request.data['paginationNumber'])
    data = paginator.get_page(paginationNumber)
    dataList = []
    for i in range(len(data)):
        author = data[i].author
        optionChoosen = ''
        if Vote.objects.filter(parentPost=post, author=author).exists():
            # if data[i] in user.postParticipatedIn.all():
            optionChoosen = Vote.objects.get(
                parentPost=post, author=author).voteLabel
        comment = {
            'id': str(data[i].id),
            'posted_at': data[i].posted_at.strftime('%Y-%m-%d %X %z'),
            'message': data[i].message,
            'userProfileImageLink': author.profile_pic_link,
            'username': author.username,
            'replyCount': data[i].replyCount,
            'optionChoosen': optionChoosen,
        }

        dataList.append(comment)

    dataListJson = json.dumps(dataList)
    return Response(data=dataListJson, status=200)


@api_view(['POST'])
@permission_classes([IsAuthenticated])
def getReplies(request):
    commentId = request.data['commentId']
    comment = Comment.objects.get(id=commentId)
    replies = comment.replycomment_set.order_by('posted_at').reverse()
    paginator = Paginator(replies, 10)
    paginationNumber = int(request.data['paginationNumber'])
    data = paginator.get_page(paginationNumber)
    dataList = []
    for i in range(len(data)):
        reply = {
            'posted_at': data[i].posted_at.strftime('%Y-%m-%d %X %z'),
            'message': data[i].message,
            'userProfileImageLink': data[i].author.profile_pic_link,
            'username': data[i].author.username,
        }

        dataList.append(reply)

    dataListJson = json.dumps(dataList)
    return Response(data=dataListJson, status=200)


@api_view(['POST'])
@permission_classes([IsAuthenticated])
def createReply(request):
    author = request.user
    message = request.data['message']
    parentCommentId = request.data['parentCommentId']
    parentComment = Comment.objects.get(id=parentCommentId)
    ReplyComment.objects.create(
        author=author,
        message=message,
        parentComment=parentComment,
    )
    parentComment.replyCount = F('replyCount')+1
    parentComment.save()
    parentComment.parentPost.totalComments = F('totalComments')+1
    parentComment.parentPost.save()
    recipient = parentComment.author
    sendNotif(title=f"{author.username} replied to your comment",imageLink=author.profile_pic_link,recipient=recipient,)

    return Response(status=200)


@api_view(['POST'])
@permission_classes([IsAuthenticated])
def vote(request):
    author = request.user
    option = request.data['option']
    parentPostId = request.data['parentPostId']
    parentPost = Post.objects.get(id=parentPostId)
    if Vote.objects.filter(parentPost=parentPost, author=author).exists():
        # if parentPost in author.postParticipatedIn.all():
        return Response(status=400)
    Vote.objects.create(author=author, parentPost=parentPost, voteLabel=option)
    recipient = parentPost.author
    sendNotif(title=f"{author.username} voted on your post",imageLink=author.profile_pic_link,recipient=recipient,)

    # if option == 'A':

    #     parentPost.option1votes = F('option1votes')+1
    # elif option == 'B':

    #     parentPost.option2votes = F('option2votes')+1
    # elif option == 'C':

    #     parentPost.option3votes = F('option3votes')+1
    # else:

    #     parentPost.option4votes = F('option4votes')+1

    # parentPost.save()
    # author.postParticipatedIn.add(parentPost)

    return Response(status=200)


@api_view(['POST'])
@permission_classes([IsAuthenticated])
def getHomePagePosts(request):
    user = request.user
    paginationNumber = int(request.data['paginationNumber'])
    authorList = [
        userRelation.chadUser for userRelation in UserRelationList.objects.filter(follower=user)]
    postsList = Post.objects.filter(
        author__in=authorList).order_by('posted_at').reverse()
    paginator = Paginator(postsList, 10)
    data = paginator.get_page(paginationNumber)
    dataList = []

    # jsonData = json.dumps(data)
    for i in range(len(data)):
        parentPost = data[i]
        optionChoosen = ''
        if Vote.objects.filter(parentPost=data[i], author=user).exists():
            # if data[i] in user.postParticipatedIn.all():
            optionChoosen = Vote.objects.get(
                parentPost=data[i], author=user).voteLabel
        option1votes = Vote.objects.filter(
            parentPost=parentPost, voteLabel='A').count()
        option2votes = Vote.objects.filter(
            parentPost=parentPost, voteLabel='B').count()
        option3votes = Vote.objects.filter(
            parentPost=parentPost, voteLabel='C').count()
        option4votes = Vote.objects.filter(
            parentPost=parentPost, voteLabel='D').count()
        post = {
            'id': str(data[i].id),
            'posted_at': data[i].posted_at.strftime('%Y-%m-%d %X %z'),
            'title': data[i].title,
            'imageUrl': data[i].imageUrl,
            'description': data[i].description,
            'section': data[i].section,
            'userProfileImage': data[i].author.profile_pic_link,
            'username': data[i].author.username,
            'votable': data[i].votable,
            'option1votes': option1votes,
            'option2votes': option2votes,
            'option3votes': option3votes,
            'option4votes': option4votes,
            'option1text': data[i].option1text,
            'option2text': data[i].option2text,
            'option3text': data[i].option3text,
            'option4text': data[i].option4text,
            'totalComments': data[i].totalComments,
            'bookmarked': 'true'if data[i] in request.user.bookmarks.all() else 'false',
            'optionChoosen': optionChoosen,
        }

        dataList.append(post)

    dataListJson = json.dumps(dataList)
    return Response(data=dataListJson, status=200)

def sendNotif(recipient=None,title='',body='',imageLink=''):
    message = Message(notification=Notification(title=title, body=body, image=imageLink))
    device = FCMDevice.objects.filter(user = recipient)
    device.send_message(message)