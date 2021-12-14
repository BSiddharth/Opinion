from authentication.models import User
from django.db import models
from django.db.models.fields import DateTimeField

# Create your models here.


class UserRelationList(models.Model):
    chadUser = models.ForeignKey(
        User, related_name='user', on_delete=models.CASCADE)
    follower = models.ForeignKey(
        User, related_name='follower', on_delete=models.CASCADE)
    followingSince = DateTimeField(auto_now_add=True)

    class Meta:
        unique_together = ('chadUser', 'follower',)
