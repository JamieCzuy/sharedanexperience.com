# Generated by Django 2.0.2 on 2018-02-15 01:16

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('people', '0001_initial'),
    ]

    operations = [
        migrations.RenameModel(
            old_name='People',
            new_name='Person',
        ),
    ]