from django.db import models
from django.db.models.deletion import CASCADE

from django.db.models.fields.related import ForeignKey
from authentication.models import User
import uuid


class Post(models.Model):
    author = ForeignKey(User, on_delete=models.CASCADE)
    imageUrl = models.CharField(max_length=200)
    title = models.CharField(max_length=150, default='')
    section = models.CharField(default='', max_length=100)
    posted_at = models.DateTimeField(auto_now_add=True)
    description = models.TextField(default='')
    votable = models.CharField(max_length=5)
    # option1votes = models.IntegerField(default=0)
    # option2votes = models.IntegerField(default=0)
    # option3votes = models.IntegerField(default=0)
    # option4votes = models.IntegerField(default=0)
    option1text = models.CharField(max_length=130, default='')
    option2text = models.CharField(max_length=130, default='')
    option3text = models.CharField(max_length=130, default='')
    option4text = models.CharField(max_length=130, default='')
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    totalComments = models.IntegerField(default=0)


class Comment(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    author = ForeignKey(User, on_delete=models.CASCADE)
    message = models.CharField(max_length=500, null=False)
    posted_at = models.DateTimeField(auto_now_add=True)
    parentPost = models.ForeignKey(Post, on_delete=models.CASCADE)
    replyCount = models.IntegerField(default=0)


class ReplyComment(models.Model):
    author = ForeignKey(User, on_delete=models.CASCADE)
    message = models.CharField(max_length=500, null=False)
    posted_at = models.DateTimeField(auto_now_add=True)
    parentComment = models.ForeignKey(Comment, on_delete=models.CASCADE)


class Vote(models.Model):
    author = ForeignKey(User, on_delete=models.CASCADE)
    parentPost = ForeignKey('Post', on_delete=models.CASCADE)
    voteLabel = models.CharField(max_length=1, null=False)
    posted_at = models.DateTimeField(auto_now_add=True)
