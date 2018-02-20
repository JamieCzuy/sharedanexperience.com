from django.shortcuts import get_object_or_404
from django.shortcuts import render

from .models import Person


def detail(request, person_id):
    person = get_object_or_404(Person, pk=person_id)
    return render(
        request,
        'people/detail.html',
        {
            'person': person,
        }
    )


def index(request):
    person_list = Person.objects.order_by('nickname')
    return render(
        request,
        'people/index.html',
        {
            'person_list': person_list,
        }
    )
