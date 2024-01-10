Configuring VaaS for deployment in the production environment

---

## Deploying with GitHub Actions

GitHub Actions is a powerful tool for automating your software development workflows. With GitHub Actions, you can build, test, and deploy your code directly from GitHub. If you are looking to deploy VaaS using GitHub Actions, you can find detailed instructions in the [GitHub Actions Documentation](docs/quick-start/github_actions.md).
==========================================
VaaS is a Django application. It can be run in multiple ways, as documented in [Django deployment documentation](https://docs.djangoproject.com/en/1.8/howto/deployment/). The example below is just one way of deploying VaaS. It uses Uwsgi, Nginx and Mysql on an Ubuntu server, as ubuntu user.

Python Support
--------------
VaaS run on Python3.8+ versions.

Please refer to [GitHub Actions Documentation](docs/quick-start/github_actions.md) for more information on deploying VaaS using GitHub Actions.

Ubuntu system packages requirements
-----------------------------------
Make sure you have installed packages on machine:

     sudo apt-get install python3.5-dev python3-venv libssl-dev libtool libldap2-dev libssl-dev libsasl2-dev libmysqlclient-dev libcurl4-openssl-dev

Build VaaS package
------------------
Use the commands below to build VaaS from source:

    git clone https://github.com/allegro/vaas.git
    python3.8 -m venv dist-env
    . dist-env/bin/activate
    pip install --upgrade pip
    cd vaas/vaas-app
    python setup.py egg_info
    pip install -r src/vaas.egg-info/requires.txt
    python setup.py sdist --format=zip

Package will be located in dist directory.

Install VaaS package
--------------------
Use the commands below to install VaaS package built in the previous step on a web server:

    python3.5 -m venv prod-env
    . prod-env/bin/activate
    pip install --upgrade pip
    pip install python-ldap==3.2.0
    pip install django-auth-ldap==1.9.0
    pip install mysqlclient==1.5.0
    pip install lck.django
    pip install uwsgi
    pip install vaas-{version-number}.zip


Configure Mysql
---------------
Install Mysql server, create a new database, and a new user for VaaS.


VaaS configuration location
---------------------------

All django related settings should be stored in location

    ~/.vaas

VaaS application handles three files in yaml format, but only one is required:
     * db_config.yml - database configuration *required*
     * production.yml - place to override some django settings *optional*
     * ldap.yml - ldap integration config *optional* - more at [ldap configuration](../documentation/ldap.md)

Configure VaaS application
--------------------------
VaaS requires the following configuration file:

db_config.yml:

    ---
    default:
      ENGINE: 'django.db.backends.mysql'
      NAME: 'vaas'
      USER: 'vaas'
      PASSWORD: 'vaas'
      HOST: 'actual_mysql_hostname'


Configure Uwsgi
---------------
One way to run Uwsgi is to configure it with upstart. Create a file called /etc/init/uwsgi.conf with the following contents:

    description "VaaS - Uwsgi Configuration"
    start on runlevel [2345]
    stop on runlevel [06]
    
    exec /home/ubuntu/prod-env/bin/uwsgi --env DJANGO_SETTINGS_MODULE=vaas.settings --uid vagrant --master --processes 8 --die-on-term --socket /tmp/vaas.sock -H /home/ubuntu/prod-env --module vaas.wsgi --chmod-socket=666 --logto /var/log/uwsgi.log

Then start uwsgi with:

    service uwsgi start


Configure Service
-----------------
For modern OS, we use the Systemd service to manage Uwsgi. Create service file /lib/systemd/system/vaas_uwsgi.service with the following contents:

    [Unit]
    Description=Varnish As A Service
    After=network.target

    [Service]
    ExecStart=//home/ubuntu/prod-env/bin/uwsgi --env DJANGO_SETTINGS_MODULE=vaas.settings --uid vagrant --master --processes 8 --die-on-term --socket /tmp/vaas.sock -H /home/vagrant/prod-env --module vaas.external.wsgi --chmod-socket=666 --logto /tmp/uwsgi.log
    Restart=on-failure
    Type=notify

    [Install]
    WantedBy=multi-user.target
    Alias=vaas.service

After add file you need to reload Systemd configuration:

    systemctl daemon-reload

Run VaaS:

    service vaas start


Configure Nginx (Modifying Nginx Configuration)
---------------
Create a file named vaas.conf in /etc/nginx/sites-available and link it to /etc/nginx/sites-enabled. Add the following contents to the file replacing SERVER_NAME with your server name:

    upstream django {
        server unix:///tmp/vaas.sock;
    }
    
    server {
        listen      80;
        server_name <SERVER_NAME>;
        charset     utf-8;
    
        client_max_body_size 75M;
    
        location /static {
            alias /home/vagrant/prod-env/local/lib/python2.7/site-packages/vaas/static;
        }
    
        location / {
            uwsgi_pass  django;
            include     /etc/nginx/uwsgi_params;
            uwsgi_read_timeout 300;
        }
    }

Then start Nginx with:

    service nginx start


Override django settings
------------------------
It's possible to override some django settings by special config file named production.yml as follow:

production.yml:

    SECURE_PROXY_SSL_HEADER: !!python/tuple ['HTTP_X_FORWARDED_PROTO', 'https']
    ALLOWED_HOSTS: [''.example.com']


Troubleshooting
---------------
If you cannot create virtualenv on Ubuntu 16.04 and have error like this:

    The virtual environment was not created successfully because ensurepip is not
    available.  On Debian/Ubuntu systems, you need to install the python3-venv
    package using the following command.

        apt-get install python3-venv -y

    You may need to use sudo with that command.  After installing the python3-venv
    package, recreate your virtual environment.

    Failing command: ['/tmp/vaas/dist-venv/bin/python3.8', '-Im', 'ensurepip', '--upgrade', '--default-pip']

You need to update your locale. For example:

    export LC_ALL="en_US.UTF-8"
    export LC_CTYPE="en_US.UTF-8"
    sudo dpkg-reconfigure locales

After that commend ```sudo python3.5 -m venv dist-venv``` will work properly.