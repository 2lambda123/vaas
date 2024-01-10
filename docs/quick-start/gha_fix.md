
2. Build the VaaS package from source:
   ```
   git clone https://github.com/allegro/vaas.git
   python3.5 -m venv dist-env
   . dist-env/bin/activate
   pip install --upgrade pip
   cd vaas/vaas-app
   python setup.py egg_info
   pip install -r src/vaas.egg-info/requires.txt
   python setup.py sdist --format=zip
   ```

3. Install the VaaS package on your web server:
   ```
   python3.5 -m venv prod-env
   . prod-env/bin/activate
   pip install --upgrade pip
   pip install python-ldap==3.2.0
   pip install django-auth-ldap==1.7.0
   pip install mysqlclient==1.4.2.post1
   pip install lck.django
   pip install uwsgi
   pip install vaas-{version-number}.zip
   ```

4. Configure MySQL by installing the server and creating a new database and user for VaaS.

5. Configure Uwsgi by creating an upstart configuration file and starting the service.

6. Configure the VaaS service using a Systemd service file and reload the Systemd configuration.

7. Configure Nginx by creating a configuration file and starting the service.

8. Override Django settings if necessary by creating a production.yml file.

### Vagrant Deployment

To deploy VaaS using Vagrant, follow these steps:

1. Install Virtual Box, Vagrant, and Git on your machine.

2. Clone the VaaS repository and navigate to the project directory:
   ```
   git clone https://github.com/allegro/vaas.git
   cd vaas
   ```

3. Start the VaaS Vagrant box: