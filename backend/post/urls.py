from django.urls import path
from . import views

app_name = "post"

urlpatterns = [
    path('createpost/', views.createPost, name='createPost'),
    path('getposts/', views.getPosts, name='getPosts'),
    path('getParticipatedPosts/', views.getParticipatedPosts,
         name='getParticipatedPosts'),
    path('bookmarkpost/', views.bookmarkPost, name='bookmarkPost'),
    path('getBookmarks/', views.getBookmarks, name='getBookmarks'),
    path('createComment/', views.createComment, name='createComment'),
    path('getComments/', views.getComments, name='getComments'),
    path('getReplies/', views.getReplies, name='getReplies'),
    path('createReply/', views.createReply, name='createReply'),
    path('vote/', views.vote, name='vote'),
    path('getHomePagePosts/', views.getHomePagePosts, name='getHomePagePosts'),
]
