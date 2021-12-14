from django.contrib import admin
from .models import User, CallBackToken


class CallBackTokenAdmin(admin.ModelAdmin):
    list_display = ('email', 'callBackToken')


class UserAdmin(admin.ModelAdmin):
    list_display = ('username', 'email', 'first_name',
                    'last_name', )


admin.site.register(User, UserAdmin)
admin.site.register(CallBackToken, CallBackTokenAdmin)
