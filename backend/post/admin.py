from django.contrib import admin
from .models import Comment, Post, Vote


class PostsAdmin(admin.ModelAdmin):
    list_display = ('author', 'title', 'posted_at')


class CommentsAdmin(admin.ModelAdmin):
    list_display = ('author', 'message', 'posted_at')


class VotesAdmin(admin.ModelAdmin):
    list_display = ('voteLabel', 'parentPost', 'author')


admin.site.register(Post, PostsAdmin)
admin.site.register(Comment, CommentsAdmin)
admin.site.register(Vote, VotesAdmin)
