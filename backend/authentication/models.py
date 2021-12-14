from django.db import models
from django.contrib.auth.models import AbstractUser
import uuid


class User(AbstractUser):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)

    email = models.EmailField(verbose_name='email',
                              unique=True, blank=False, max_length=60)
    username = models.CharField(
        verbose_name='username', blank=False, unique=True, max_length=20)
    first_name = models.CharField(
        verbose_name='first name', blank=False, unique=False, max_length=20)
    last_name = models.CharField(
        verbose_name='last name', blank=True, unique=False, max_length=20)
    profile_pic_link = models.TextField(
        verbose_name='profile pic link', blank=False, default="")
    description = models.CharField(
        verbose_name='description', blank=True, default="", max_length=20)
    about = models.TextField(
        verbose_name='about', blank=True, default="", max_length=150)

    bookmarks = models.ManyToManyField('post.Post', blank=True)
    # deviceToken = models.CharField(verbose_name='device token', blank=True, default="",max_length=200)

    # postParticipatedIn = models.ManyToManyField(
    #     'post.Post', related_name='postparticipatedin')


class CallBackToken(models.Model):
    email = models.EmailField(verbose_name='email',
                              unique=True, blank=False, max_length=60)
    callBackToken = models.IntegerField(
        verbose_name='call back token', blank=False, unique=False)
