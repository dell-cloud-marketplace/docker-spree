#docker-spree
This is a base Docker image to run a [Spree Commerce](http://spreecommerce.com/) - an open-source e-commerce Rails application.



## Components
The software stack comprises the following components:

Name          | Version    | Description
--------------|------------|------------------------------
Ubuntu        | Trusty     | Operating system
Spree         | 2.3.4      | E-commerce software
Ruby          | 2.1.4      | Programming language
Ruby on Rails | 4.1.6      | Web application framework
MySQL         | 5.6        | Database

## Usage

### Start the container

To start your container with:

* A named container ("spree")
* Host port 3000 mapped to container port 3000 (default Spree application port)
* Host port 3306 mapped to container port 3306 (default MySQL port)

Do:

    sudo docker run -d -p 3000:3000 -p 3306:3306 --name spree dell/spree

and access Spree application from your browser:

    http://localhost:3000/

### Advanced Example 1
To start your image with an app volume (which will survive a restart) for the Spree application this includes the database and configuration files, do:

    sudo docker run -d -p 3000:3000 -v /app:/app --name spree dell/spree

### Advanced Example 2
* To start your image with two data volumes (which will survive a restart). The MySQL data is available in ***/data/mysql*** on the host. The Spree application files are available in ***/app*** on the host.
* A predefined password for the MySQL admin user.

    sudo docker run -d \
    -p 3000:3000 \
    -p 3306:3306 \
    -v /app:/app \
    -v /data/mysql:/var/lib/mysql \
    -e MYSQL_PASS="mypass"  \
    --name spree \
    dell/spree


## Administration

### Connecting to MySQL
The first time that you run your container, a new user admin with all privileges will be created in MySQL with a random password. To get the password, check the container logs (```docker logs spree```). You will see output like the following:
    
You will see some output like the following:

    ===================================================================
    You can now connect to this MySQL Server using:

        mysql -u admin -p47nnf4FweaKu -h<host> -P<port>

    Please remember to change the above password as soon as possible!
    MySQL user 'root' has no password but only allows local connections
    ===================================================================


In this case, **ca1w7dUhnIgI** is the password allocated to the admin user.

You can then connect to the admin console...

    mysql -u admin -p ca1w7dUhnIgI --host 127.0.0.1 --port 3306

     
###Administration Web Console

The Spree administration console can be accessed by the below URL. The default credentials are username ```spree@example.com``` and password ```spree123```.


     http://localhost:3000/admin


###Database Management

Spree Database configuration details can be located from Database.yaml, currently there is no sample data (please see below if you wish to add sample data). If changes to the database are required the tool rake is used from within the container. 

Currently (with Docker 1.2), the first step is to install [nsenter](https://github.com/jpetazzo/nsenter) on the host. If you are a DCM user, please ssh into the instance and go to the ***/app*** directory. Below are a few useful commands.

To create a new database and apply the migrations, do:
    
    rake db:create db:migrate

In case you wish to seed the database with some data the below commands can be run, do:

    rake db:seed rake db:sample

###Customisation

Spree supports extensions that provide the facility to customise Spree website. Extensions are reusable  code that facilitate a range of functionality, they can be found in the  [Spree Extension Registry](http://spreecommerce.com/extensions). Extensions can be installed by adding it to the bottom of the Gemfile file(this resides in the project root folder /app).  Further information on installing and existing alternatively creating your own is detailed from the [Spree Developers Guide](http://guides.spreecommerce.com/developer/extensions_tutorial.html). Any gems added to Gemfile will require the bundler to be run from here.

To Do:

     bundle install
     
Followed by copying the necessary migrations if it is an extension.

    bundle exec rails g gem_name:install

In general Spree follows an MVC framework. Models, views and controllers reside under directory ***/app/app***. The assets directory is where the stylesheets, JavaScript and images can be found. There are guidelines on how best to customise Spree website in particular [Spree’s Asset Pipeline](https://github.com/spree/spree-guides/blob/master/content/developer/customization/asset.markdown).

###Guides

There is comprehensive documentation on using Spree, customisation and REST API information. This can be found from the below URL.

* [Spree Guides](http://guides.spreecommerce.com/)
* [Spree API Guide](http://guides.spreecommerce.com/api/)
* [Spree Source](https://github.com/spree/spree/tree/2-4-stable)



## Reference

### Image Details

Based on [rlister/dockerfiles](https://github.com/rlister/dockerfiles/tree/master/spree)

Pre-built Image   | [https://registry.hub.docker.com/u/dell/spree](https://registry.hub.docker.com/u/dell/spree) 
