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

Do:

    sudo docker run -d -p 3000:3000 --name spree dell/spree


and access Spree application from your browser:

    http://localhost:3000/

### Advanced Example 1
To start your image with a app volume (which will survive a restart) for the Spree application, database and configuration files, do:

    sudo docker run -d -p 3000:3000 -v /app:/app --name spree dell/spree

The Spree application, database and configuration files will be available in **/app** on the host.


###Administration Console

The Spree administration console can be accessed by the below URL. The default credentials are username ```spree@example.com``` and password ```spree123```.


     http://localhost:3000/admin


###Database Management


###Customisation

Spree supports extensions that provide the facility to customise Spree website. Extensions are reusable  code that facilitate a range of functionality, they can be found in the  [Spree Extension Registry](http://spreecommerce.com/extensions). Extensions can be installed by adding it to the bottom of the Gemfile file(this resides in the project root folder /app).  Further information on installing and existing alternatively creating your own is detailed from the [Spree Developers Guide](http://guides.spreecommerce.com/developer/extensions_tutorial.html).

Currently (with Docker 1.2), the first step is to install [nsenter](https://github.com/jpetazzo/nsenter) on the host. If you are a DCM user, please ssh into the instance to the ***/app*** folder. In the root of this project you will find a Gemfile. Any gems added to this file will require bundler to be run from here.

To Do:

     bundle install
     
Followed by copying the necessary migrations if it is an extension.

    bundle exec rails g gem_name:install

In general Spree follows an MVC framework. Models, views and controllers reside under directory ***/app/app***. The assets directory is where the stylesheets, JavaScript and images can be found. There are guidelines on how best to customise Spree website in particular Spree’s Asset Pipeline (https://github.com/spree/spree-guides/blob/master/content/developer/customization/asset.markdown).

###Administration

There is comprehensive documentation on using Spree, customisation and REST API information. This can be found from the below URL.

* [Spree Guides](http://guides.spreecommerce.com/)
* [Spree API Guide](http://guides.spreecommerce.com/api/)
* [Spree Source](https://github.com/spree/spree/tree/2-4-stable)



## Reference

### Image Details

Based on [rlister/dockerfiles](https://github.com/rlister/dockerfiles/tree/master/spree)

Pre-built Image   | [https://registry.hub.docker.com/u/dell/spree](https://registry.hub.docker.com/u/dell/spree) 
