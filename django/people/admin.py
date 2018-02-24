from django.contrib import admin

from .forms import PersonForm
from .models import Person


@admin.register(Person)
class PersonAdmin(admin.ModelAdmin):
    actions = None
    form = PersonForm
    list_display = ('nickname', 'full_name', 'created', 'modified')
    ordering = ('nickname',)
