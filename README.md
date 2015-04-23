# docker-spree
This image installs [Spree Commerce](http://spreecommerce.com/), an open-source, e-commerce Rails application. 

The image extends [dell/docker-passenger-base](https://github.com/dell-cloud-marketplace/docker-passenger-base) which, in turn, adds Phusion Passenger and Ngnix to [dell/docker-rails-base](https://github.com/dell-cloud-marketplace/docker-rails-base/). Please refer to the image README.md files for further information.

## Components
The software stack comprises the following components:

Name              | Version    | Description
------------------|------------|------------------------------
Ubuntu            | Trusty             | Operating system
Spree             | 3.0              | E-commerce software
MySQL             | 5.5                | Database
Phusion Passenger | see [docker-passenger-base](https://github.com/dell-cloud-marketplace/docker-passenger-base/)          | Application server
Nginx             | see [docker-passenger-base](https://github.com/dell-cloud-marketplace/docker-passenger-base/)            | Web server
Ruby              | see [docker-rails-base](https://github.com/dell-cloud-marketplace/docker-rails-base/) | Programming language
Ruby on Rails     | see [docker-rails-base](https://github.com/dell-cloud-marketplace/docker-rails-base/)     | Web application framework

## Usage

### 1. Start the Container
If you wish to create data volumes, which will survive a restart or recreation of the container, please follow the instructions in [Advanced Usage](#advanced-usage).

#### A. Basic Usage
Start the container with:

* A named container ("spree")
* Ports 80, 443 (Nginx) and 3306 (MySQL) exposed

As follows:

```no-highlight
sudo docker run -d -p 80:80 -p 443:443 -p 3306:3306 --name spree dell/spree
```

<a name="advanced-usage"></a>
#### B. Advanced Usage
Start your container with:

* A named container ("spree")
* Ports 80, 443 (Nginx) and port 3306 (MySQL) exposed
* Four data volumes (which will survive a restart or recreation of the container). The Spree application files are available in **/app** on the host. The Nginx website configuration files are available in **/data/nginx** on the host. The Nginx log files are available in **/var/log/nginx** on the host. The MySQL data is available in **/data/mysql** on the host.
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

### 2. Check the Log Files

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
```no-highlight
mysql -u admin -p 47nnf4FweaKu --host 127.0.0.1 --port 3306
```

## Test your Deployment

The Spree application takes about a minute to start up, as various scripts are run. You can check the progress by following the logs '**sudo docker logs --follow spree**' until the Nginx service is running.

To access the website, open:
```no-highlight
http://localhost
```

Or use cURL:
```no-highlight
curl http://localhost
```

The container supports SSL, via a self-signed certificate. **We strongly recommend that you connect via HTTPS**, if the container is running outside your local machine (e.g. in the Cloud). Your browser will warn you that the certificate is not trusted. If you are unclear about how to proceed, please consult your browser's documentation on how to accept the certificate.

```no-highlight
https://localhost
```

### Administration Web Console

The Spree administration console can be accessed via the following URL:

```no-highlight
https://localhost/admin
```

 The default credentials are (email) ```spree@example.com``` and (password) ```spree123```. **Please change these details immediately** (select menu item **My Account**, then **Edit**).

### Nginx Configuration

If you used the volume mapping option as listed in the [Advanced Usage](#advanced-usage), you can directly change the Nginx configuration under **/data/nginx/** on the host. To restart the configuration, enter the container using [nsenter](https://github.com/dell-cloud-marketplace/additional-documentation/blob/master/nsenter.md), and do:

```no-highlight
supervisorctl restart nginx
```

As the Nginx service restarts, the child processes (Passenger) will also restart, spawning new PIDs. You will see messages similar to the following, in the Docker logs:

```no-highlight
2014-12-16 12:15:38,083 CRIT reaped unknown pid 2806)
2014-12-16 12:15:38,085 CRIT reaped unknown pid 2811)
2014-12-16 12:15:39,118 CRIT reaped unknown pid 2842)
```

### Environment

The Spree application is deployed in development mode. Details on environment settings for Phusion Passenger with Nginx and Spree may be found here:

* [Phusion Passenger](https://www.phusionpassenger.com/documentation/Users%20guide%20Nginx.html#PassengerAppEnv)
* [Spree Deployment](https://guides.spreecommerce.com/developer/deployment_tips.html)
* [Ruby on Rails configuration](http://guides.rubyonrails.org/configuring.html)

### Database Management

The Spree database configuration details are in **/app/config/database.yml**. If changes to the database are required, use [nsenter](https://github.com/dell-cloud-marketplace/additional-documentation/blob/master/nsenter.md) to enter the container,  and run **rake** commands from the **/app** directory.

### Customisation

It is possible to customise Spree by using extensions. Examples can be found in the [Spree Extension Registry](http://spreecommerce.com/extensions).

To install an extension:

1. Enter the container via [nsenter](https://github.com/dell-cloud-marketplace/additional-documentation/blob/master/nsenter.md) (if you are a DCM user, please ssh into the instance).
2. Go to the project root folder, **/app** (which is also accessible from the host if volume mapping has been added).
3. Add the extension to the bottom of the Gemfile.
4. Run Bundler.

```no-highlight
bundle install
```

Finally, copy over the required migrations and assets from the extension:

```no-highlight
bundle exec rails g (gem name):install
```

For more information, please refer to the [Spree Developers Guide](http://guides.spreecommerce.com/developer/extensions_tutorial.html).

### Getting Started
The following links are a good starting point on how to use and customise Spree:

* [Spree Guides](http://guides.spreecommerce.com/)
* [Spree API Guide](http://guides.spreecommerce.com/api/)
* [Spree Source](https://github.com/spree/spree/tree/3-0-stable)
* [Spree’s Asset Pipeline](https://github.com/spree/spree-guides/blob/master/content/developer/customization/asset.markdown)

## Reference

### Image Details

Inspired by [rlister/dockerfiles](https://github.com/rlister/dockerfiles/tree/master/spree)

Pre-built Image | [https://registry.hub.docker.com/u/dell/spree](https://registry.hub.docker.com/u/dell/spree) 
