from django.db import models


class Person(models.Model):
    nickname = models.TextField()
    full_name = models.TextField()

    def __str__(self):
        return self.nickname
