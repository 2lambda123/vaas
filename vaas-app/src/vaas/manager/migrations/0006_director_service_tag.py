# Generated by Django 3.1.13 on 2021-10-20 09:54

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('manager', '0005_director_service_mesh_label'),
    ]

    operations = [
        migrations.AddField(
            model_name='director',
            name='service_tag',
            field=models.CharField(blank=True, default='', max_length=128),
        ),
    ]