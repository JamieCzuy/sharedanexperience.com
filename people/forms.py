from django import forms
from django.forms import ModelForm

from .models import Person


class PersonForm(ModelForm):
    nickname = forms.CharField(widget=forms.Textarea(attrs={'cols': '80', 'rows': '1'}))
    full_name = forms.CharField(widget=forms.Textarea(attrs={'cols': '80', 'rows': '1'}))

    class Meta:
        model = Person
        fields = (
            'nickname',
            'full_name',
        )
