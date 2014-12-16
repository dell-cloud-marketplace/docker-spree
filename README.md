# docker-spree
This image installs [Spree Commerce](http://spreecommerce.com/) - an open-source e-commerce Rails application. 
It extends the [dell/docker-passenger-base](https://github.com/dell-cloud-marketplace/docker-passenger-base) image which adds Phusion Passengner and Ngnix. Please refer to the README.md for selected images for further information.

## Components
The software stack comprises the following components:

Name              | Version    | Description
------------------|------------|------------------------------
Ubuntu            | Trusty             | Operating system
Spree             | 2.3.4              | E-commerce software
MySQL             | 5.6                | Database
Phusion Passenger | see [docker-passenger-base](https://github.com/dell-cloud-marketplace/docker-passenger-base/)          | Web server
Nginx             | see [docker-passenger-base](https://github.com/dell-cloud-marketplace/docker-passenger-base/)            | HTTP server & Reverse proxy
Ruby              | see [docker-rails](https://github.com/dell-cloud-marketplace/docker-rails/) | Programming language
Ruby on Rails     | see [docker-rails](https://github.com/dell-cloud-marketplace/docker-rails/)     | Web application framework

## Usage

### 1. Start the container
If you wish to create data volumes, which will survive a restart or recreation of the container, please follow the instructions in [Advanced Usage](#advanced-usage).

#### A. Basic Usage
Start the container:

* A named container ("spree")
* Ports 80, 443 (Nginx) and 3306 (MySQL port) exposed

As follows:

```no-highlight
sudo docker run -d -p 80:80 -p 443:443 -p 3306:3306 --name spree dell/spree
```

<a name="advanced-usage"></a>
#### B. Advanced Usage
Start your container with:

* A named container ("spree")
* Ports 80, 443 (Nginx) and port 3306 (MySQL port) exposed
* Four data volumes (which will survive a restart or recreation of the container). The Spree application files are available in **/app** on the host. The Nginx website configuration files are available in **/data/nginx** on the host. The Nginx log files are available in **/var/log/nginx** on the host. The MySQL data is available in ***/data/mysql*** on the host.
* A predefined password for the MySQL admin user.

As follows:

```no-highlight
sudo docker run -d \
 -p 80:80 \
 -p 443:443 \
 -p 3306:3306 \
 -v /app:/app \
 -v /var/log/nginx:/var/log/nginx \
 -v /data/nginx:/opt/nginx/conf \
 -v /data/mysql:/var/lib/mysql \
 -e MYSQL_PASS="mypass"  \
 --name spree dell/spree
```

## Check the Log Files

If you haven't defined a MySQL password, the container will generate a random one. Check the logs for the password by running:

```no-highlight
sudo docker logs spree
```

You will see output like the following:

```no-highlight
    ===================================================================
    You can now connect to this MySQL Server using:

        mysql -u admin -p47nnf4FweaKu -h<host> -P<port>

    Please remember to change the above password as soon as possible!
    MySQL user 'root' has no password but only allows local connections
    ===================================================================
```

In this case, **47nnf4FweaKu** is the password allocated to the admin user.

You can then connect to the admin console...

    mysql -u admin -p 47nnf4FweaKu --host 127.0.0.1 --port 3306

## Test your deployment

The Spree application can take some time to run due to scripts executed at start up but this usually is under a minute. You can check the progress by following the logs '**sudo docker logs --follow spree**' until the Nginx service is running.

To access the website, open:
```no-highlight
http://localhost
```
Or:

```no-highlight
https://localhost
```

**We strongly recommend that you connect via HTTPS**, for this step, and all subsequent administrative tasks, if the container is running outside your local machine (e.g. in the Cloud). Your browser will warn you that the certificate is not trusted. If you are unclear about how to proceed, please consult your browser's documentation on how to accept the certificate.

Or with cURL:
```no-highlight
curl http://localhost
```

###Administration Web Console

The Spree administration console can be accessed by the below URL. Enter the admin default credentials username ```spree@example.com``` and password ```spree123```.

     http://localhost/admin

###Nginx Configuration

If you used the volume mapping option as listed in the [Advanced Usage](#advanced-usage), you can directly change the Nginx configuration under **/data/nginx/** on the host. A reload of the Nginx server is required once changes have been made.

* Restart Nginx Configuration

```no-highlight
supervisorctl restart nginx
```

As the Nginx service does a reload the child processes (Passenger) will also do a restart, spawning a new pid. Please note the below message will occur in the docker logs as a result:

```no-highlight
2014-12-16 12:15:38,083 CRIT reaped unknown pid 2806)
2014-12-16 12:15:38,085 CRIT reaped unknown pid 2811)
2014-12-16 12:15:39,118 CRIT reaped unknown pid 2842)
```

###Environment

The Spree application has been deployed to a development environment, details on environment settings for Phusion Passenger with Nginx and Spree are as follow:

* [Phusion Passenger](https://www.phusionpassenger.com/documentation/Users%20guide%20Nginx.html#PassengerAppEnv)
* [Spree Deployment](https://guides.spreecommerce.com/developer/deployment_tips.html)
* [Ruby on Rails configuration](http://guides.rubyonrails.org/configuring.html)

###Database Management

Spree database configuration details can be located from database.yml on the host if volume mapping is set up. If changes to the database are required the tool rake is used from within the container. 

Currently (with Docker 1.2), the first step is to install [nsenter](https://github.com/jpetazzo/nsenter) on the host. If you are a DCM user, please ssh into the instance. Rake commands are run from the ***/app*** directory.

###Customisation

Spree supports extensions that provide the facility to customise Spree website. Extensions are reusable  code that facilitate a range of functionality, they can be found in the  [Spree Extension Registry](http://spreecommerce.com/extensions). Extensions can be installed by adding it to the bottom of the Gemfile file(this resides in the project root folder ***/app*** which can be accessed from the host if volume mapping has been added). Further information on installing and existing alternatively creating your own is detailed from the [Spree Developers Guide](http://guides.spreecommerce.com/developer/extensions_tutorial.html). Any gems added to Gemfile will require the bundler to be run from directory ***/app*** from within the container.

To Do:

    bundle install
 
Followed by copying the necessary migrations if it is an extension.

    bundle exec rails g gem_name:install

In general Spree follows an MVC framework. Models, views and controllers reside under directory ***/app/app***. The assets directory is where the stylesheets, JavaScript and images can be found. There are guidelines on how best to customise Spree website in particular [Spree’s Asset Pipeline](https://github.com/spree/spree-guides/blob/master/content/developer/customization/asset.markdown).

###Getting Started

There is comprehensive documentation on using Spree, customisation and REST API information. Below are some guidelines and documentation as a starting guide.

* [Spree Guides](http://guides.spreecommerce.com/)
* [Spree API Guide](http://guides.spreecommerce.com/api/)
* [Spree Source](https://github.com/spree/spree/tree/2-4-stable)



## Reference

### Image Details

Based on [rlister/dockerfiles](https://github.com/rlister/dockerfiles/tree/master/spree)

Pre-built Image   | [https://registry.hub.docker.com/u/dell/spree](https://registry.hub.docker.com/u/dell/spree) 
