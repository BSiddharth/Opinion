from django.urls import path
from . import views

app_name = 'authentication'

urlpatterns = [
    path('auth/email/', views.validateEmail, name='validateEmail'),
    path('auth/email/token/', views.submitCallBackToken,
         name='submitCallBackToken'),
    path('auth/createuser/', views.createUser, name='createUser'),
    path('auth/googleSignIn/', views.googleSignIn, name='googleSignIn'),
]
