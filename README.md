#docker-spree
This is a base Docker image to run a [Spree Commerce](http://spreecommerce.com/) - an open-source e-commerce Rails application.



## Components
The software stack comprises the following components:

Name          | Version    | Description
--------------|------------|------------------------------
Ubuntu        | Trusty             | Operating system
Spree         | 2.3.4              | E-commerce software
MySQL         | 5.6                | Database
Ruby          | see [docker-rails](https://github.com/dell-cloud-marketplace/docker-rails/) | Programming language
Ruby on Rails | see [docker-rails](https://github.com/dell-cloud-marketplace/docker-rails/)     | Web application framework

## Usage

### Start the container

To start your container with:

* A named container ("spree")
* Host port 3000 mapped to container port 3000 (default Spree application port)
* Host port 3306 mapped to container port 3306 (default MySQL port)

Do:

    sudo docker run -d -p 3000:3000 -p 3306:3306 --name spree dell/spree

To access the Spree application from your browser (this can take some time due to scripts running during container start up but usually is under a mintue), do:

    http://localhost:3000/

### Advanced Example 1
To start your image with an app volume (which will survive a restart) for the Spree application this includes the database and configuration files, do:

    sudo docker run -d -p 3000:3000 -p 3306:3306 -v /app:/app --name spree dell/spree

### Advanced Example 2
* To start your image with two data volumes (which will survive a restart). The MySQL data is available in ***/data/mysql*** on the host. The Spree application files are available in ***/app*** on the host.
* A predefined password for the MySQL admin user.

```no-highlight
    sudo docker run -d \
    -p 3000:3000 \
    -p 3306:3306 \
    -v /app:/app \
    -v /data/mysql:/var/lib/mysql \
    -e MYSQL_PASS="mypass"  \
    --name spree \
    dell/spree
```

## Administration

### Connecting to MySQL
The first time that you run your container, a new user 'admin' with all privileges will be created in MySQL with a random password. To get the password, check the container logs (```docker logs spree```). You will see output like the following:

    ===================================================================
    You can now connect to this MySQL Server using:

        mysql -u admin -p47nnf4FweaKu -h<host> -P<port>

    Please remember to change the above password as soon as possible!
    MySQL user 'root' has no password but only allows local connections
    ===================================================================


In this case, **47nnf4FweaKu** is the password allocated to the admin user.

You can then connect to the admin console...

    mysql -u admin -p 47nnf4FweaKu --host 127.0.0.1 --port 3306

     
###Administration Web Console

The Spree administration console can be accessed by the below URL. Enter the admin default credentials username ```spree@example.com``` and password ```spree123```.

     http://localhost:3000/admin


###Database Management

Spree database configuration details can be located from database.yml on the host if volume mapping is set up. If changes to the database are required the tool rake is used from within the container. 

Currently (with Docker 1.2), the first step is to install [nsenter](https://github.com/jpetazzo/nsenter) on the host. If you are a DCM user, please ssh into the instance. Below are a few useful commands that should be run from the ***/app*** directory. Please note the updated changes will require a Rails Server restart from the container.

###Customisation

Spree supports extensions that provide the facility to customise Spree website. Extensions are reusable  code that facilitate a range of functionality, they can be found in the  [Spree Extension Registry](http://spreecommerce.com/extensions). Extensions can be installed by adding it to the bottom of the Gemfile file(this resides in the project root folder ***/app*** which can be accessed from the host).  Further information on installing and existing alternatively creating your own is detailed from the [Spree Developers Guide](http://guides.spreecommerce.com/developer/extensions_tutorial.html). Any gems added to Gemfile will require the bundler to be run from directory ***/app*** from within the container.

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
