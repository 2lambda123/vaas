name: VaaS Deployment

on:
  push:
    branches:
      - main

jobs:
  deploy:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout repository
        uses: actions/checkout@v2

      - name: Set up Python
        uses: actions/setup-python@v2
        with:
          python-version: 3.8

      - name: Install dependencies
        run: pip install -r requirements.txt

      - name: Build VaaS package
        run: python setup.py sdist --format=zip

      - name: Configure database
        run: python manage.py migrate

      - name: Start application server
        run: python manage.py runserver
