#!/bin/bash
while true ; do
  su -c "\
  DJANGO_SETTINGS_MODULE=vaas.settings.docker /home/vagrant/prod-env/bin/django-admin.py backend_statuses"\
  vagrant
  sleep 120
done
