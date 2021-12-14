from django.urls import path
from . import views

app_name = 'users'

urlpatterns = [
    path('getFollowing/', views.getFollowing, name='getFollowing'),
    path('getFollowers/', views.getFollowers, name='getFollowers'),
    path('searchUser/', views.searchUser, name='searchUser'),
    path('follow/', views.follow, name='follow'),
    path('unfollow/', views.unfollow, name='unfollow'),
    path('getUserDetails/', views.getUserDetails, name='getUserDetails'),
    path('updateUserDetails/', views.updateUserDetails, name='updateUserDetails'),
    path('setDeviceToken/', views.setDeviceToken, name='setDeviceToken'),
]
