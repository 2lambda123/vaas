#!/usr/bin/env bash

exec celery --workdir=/home/app/vaas \
  -A vaas.settings worker \
  --loglevel=DEBUG \
  --concurrency=1 \
  -Q worker_queue
