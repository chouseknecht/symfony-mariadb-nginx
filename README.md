# symfony-mariadb-nginx

A framework for building containerized [symfony](https://symfony.com/) applications. Includes: PHP 7, symfony 3, composer, nginx, mariadb, and php-fpm. Run containers on your laptop while you develop, and when you're ready, instantly deploy them to the cloud for testing.

Get started developing in containers without having to deal with all the configuration, plus get built-in tools for deploying and testing on [OpenShift 3](https://www.openshift.org/) or [Kubernetes](http://kubernetes.io/).

Start with containers and deploy with containers, all within the same framework. No duplication. No wasted effort.

*Table of contents:*

  - [Requirements](#requirements)
  - [Start with an empty project](#getting-started)
  - [Start with the symfony demo project](#symfony-demo)
  - [Run a production build](#production-build)
  - [Deploy to OpenShift](#openshift)
  - [What's next?](#next)
  - [License](#license)
  - [Dependencies](#dependencies)
  - [Author](#author)

<h2 id="requirements">Requirements</h2>

- [Ansible](http://docs.ansible.com/ansible/intro_installation.html)
- The latest [Ansible Container](https://github.com/ansible/ansible-container) installed from source
- make
- [Docker Engine](https://www.docker.com/products/docker-engine) or [Docker Machine](https://docs.docker.com/machine/install-machine/)
- git
- a local clone of this project:
    
    ```
    # Set your working directory to a project folder or work space
    $ cd projects
    
    # Make a clone
    $ git clone git@github.com:chouseknecht/symfony-mariadb-nginx.git
    ```

If installing Docker Machine, we recommend installing version 1.11.2.

<h2 id="getting-started">Start with an empty project</h2>

If you want to hop in and start creating your next symfony masterpiece, the following will get started with a blankr project. If you're looking to kick the tires a bit and see how things work, you may want to [start with the symfony demo](#symfony-demo).

To get started developing, you'll first need to clone this project and have the requirements installed. Once you've got that, then run the following commands to setup your development environment: 

```
# Set the working directory to the root of the cloned project
$ cd symfony-mariadb-nginx

# Build the images. WARNING: the following command will remove any project you may have 
# in the *symphony* folder.
$ make build_from_scratch

# Run in development mode
$ make run
```
The `make run` command, which runs `ansible-container run`, takes a few minutes to finish. When it does, you will see the following message from the *symfony* container:

```
symfony_1            |  ✔  Symfony 3.1.6 was successfully installed. Now you can:
symfony_1            |
symfony_1            |     * Change your current directory to /symfony/symfony
symfony_1            |
symfony_1            |     * Configure your application in app/config/parameters.yml file.
symfony_1            |
symfony_1            |     * Run your application:
symfony_1            |         1. Execute the php bin/console server:start command.
symfony_1            |         2. Browse to the http://localhost:8000 URL.
symfony_1            |
symfony_1            |     * Read the documentation at http://symfony.com/doc
symfony_1            |
symfony_1            | + cd /symfony/symfony
symfony_1            | + exec php bin/console server:run 0.0.0.0:8000
symfony_1            |
symfony_1            |  [OK] Server running on http://0.0.0.0:8000
symfony_1            |
symfony_1            |  // Quit the server with CONTROL-C.
symfony_1            |
```

The *symfony* and *mariadb* services are now running in the foreground, and output from each is being displayed in your terminal window. Since we're in development mode the *nginx* service is not needed, and so you may have noticed it quietly stop at the beginning.

The root of the project is mounted to */symfony* in the *ansible_symfony_1* container, and an empty project called *symfony* is automatically created at */symfony/symfony*, so inside the container you can access the project at */symfony/symfony*, and outside the container you can access it directly in the *symfony* folder found in the project root.

### Accessing the web server

During development the PHP web server is running in the *ansible_symfony_1* container and is available on port 8000. You can access it in a web browser using the IP address of your Docker host. If you're running Docker Machine this will be the IP address of the vagrant box, which you can get by running `docker-mahine ip default`, where *default* is the name of the vagrant box.

When you visit the web site at [http://_your_docker_host_ip:8000](http://127.0.0.1:8000), you will see the following default symfony page:

<img src="https://github.com/chouseknecht/symfony-mariadb-nginx/blob/images/img/empty-project-page.png" alt="New project page" />

### Running console commands

Using a separate terminal window, you can run console commands using `make console` and pasing parameters. Using `docker exec` the console command will execute inside the *ansible_symfony_1* conainer and display output in your terminal window.

### Running compose commands

The *ansible_symfony_1* container includes composer, and you can access it using `make composer` and passing parameters. The make commands invokes `docker exec` to run the actual command inside the contianer, and the output is displayed in your terminal window. 

### Running commands directly

You can shell into the *ansible_symfony_1* container directly by running `docker exec -it ansible_symfony_1 /bin/bash`. This will put you at a bash shell prompt inside the container, and from there you can execut *php* and *composer* command directly.

### php.ini

A template is used to create the *php.ini* file that used in both symfony and nginx containers. Variables used in the template are set in *ansible/group_vars/all*.

<h2 id="symfony-demo">Start with the symfony demo project</h2>

Instead of starting with an empty project, you can start with a fully functioning demo, try it out, deploy it, and see how the framework performs.

You'll need to first clone this project and install the requirements. Once you've completed that, then run the following commands to start the demo:

```
# Set the working directory to the root of the clone
$ cd symfony-mariadb-nginx

# Build the images. WARNING: the following command will remove any project you may have 
# in the *symphony* folder.
$ make build_from_scratch

# Run the demo project
$ make demo
```
When the `make demo` command completes, you will see the following output in the terminal window:

```
symfony_1            |  --- ------------------------------ ------------------
symfony_1            |       Bundle                         Method / Error
symfony_1            |  --- ------------------------------ ------------------
symfony_1            |   ✔   FrameworkBundle                relative symlink
symfony_1            |   ✔   WhiteOctoberPagerfantaBundle   relative symlink
symfony_1            |  --- ------------------------------ ------------------
symfony_1            |
symfony_1            |  [OK] All assets were successfully installed.
symfony_1            |
symfony_1            | > Sensio\Bundle\DistributionBundle\Composer\ScriptHandler::installRequirementsFile
symfony_1            | > Sensio\Bundle\DistributionBundle\Composer\ScriptHandler::prepareDeploymentTarget
symfony_1            |     Skipped installation of bin bin/doctrine-dbal for package doctrine/dbal: file not found in package
symfony_1            |     Skipped installation of bin bin/doctrine for package doctrine/orm: file not found in package
symfony_1            |     Skipped installation of bin bin/doctrine.php for package doctrine/orm: file not found in package
symfony_1            | + php bin/console doctrine:schema:create
mariadb_1            | 2016-11-05  2:06:34 140288996005632 [Warning] IP address '172.17.0.4' could not be resolved: Name or service not known
symfony_1            | ATTENTION: This operation should not be executed in a production environment.
symfony_1            |
symfony_1            | Creating database schema...
symfony_1            | Database schema created successfully!
symfony_1            | + php bin/console doctrine:fixtures:load --no-interaction
symfony_1            |   > purging database
symfony_1            |   > loading AppBundle\DataFixtures\ORM\LoadFixtures
symfony_1            | + cd /symfony/symfony
symfony_1            | + exec php bin/console server:run 0.0.0.0:8000
symfony_1            |
symfony_1            |  [OK] Server running on http://0.0.0.0:8000
symfony_1            |
symfony_1            |  // Quit the server with CONTROL-C.
```
The *symfony* and *mariadb* services are now running in the foreground, and output from each is being displayed in your terminal window. Since we're in development mode the *nginx* service is not needed, and so you may have noticed it quietly stop at the beginning.

The root of the project is mounted to */symfony* in the *ansible_symfony_1* container, and an empty project called *symfony* is automatically created at */symfony/symfony*, so inside the container you can access the project at */symfony/symfony*, and outside the container you can access it directly in the *symfony* folder found in the project root. 

### Accessing the web server

The PHP web server is running inside *ansible_symfony_1* and listening on port 8000. You an access the server using a web browser and pointing to port 8000 at the IP address of your Docker host. If you're running Docker Engine, then the IP address is most likely *127.0.0.1*. If you're running Docker Machine, you'll need the IP address of the vagrant box, which you can get by running `docker-machine ip default`, where *default* is the name of your vagrant box.

When you access the web site at [http://_your_docker_host_ip:8000](http://127.0.0.1:8000), you will see the following page:

<img src="https://github.com/chouseknecht/symfony-mariadb-nginx/blob/images/img/demo-app-page.png" alt="Demo app page" />

During the startup of the *ansible_symfony_1* container, commands were automatically executed to create the *mysql* database, create the schema, and load the sample data. If you click the *Browse backend* button, for example, you will be able to click the *Login* button and see live data from the *mariadb* service.

<h2 id="production-build">Run a production build</h2>

When you reach a point where you're ready to perform a build and test your code, run the following commands to rebuild the application and run it in *production mode*. This changes the configuration of the project to use the *mariadb* and *nginx* services with your code deployed as a static asset inside the *nginx* container, representing a typical production configuration. 

Execute the following commands to launch the project in *production mode* with either the empty project, the demo project, or your own custom code in the *symfony* directory:

```
# Set the working directory to the root of the clone
$ cd symfony-mariadb-nginx

# Rebuild the images. This will copy your latest app code into the nginx image.
$ make build

# Rund the containers in production mode
$ make run_prod
```
Now you'll have the *mariadb* and *nginx* services running in the foreground, and this time the symfony service quietly stopped.

We don't want to run the PHP web server in production. Instead, we want to run something more robust like Nginx with PHP-FPM FastCGI, and so that's exactly what we're doing here.  

The *nginx* service has a copy of the app code deployed as a static asset to */var/www/nginx/*, in the same way we would deploy to a typical production web server, and inside the *nginx* container we're running supervisord to manage an nginx process and a php-fpm process. The nginx process listens for requests on port 8888, and forwards valid requests to the php-fpm process via a Unix socket.

### Load demo data

Since we're storing the database inside the *mariadb* container, the database gets destroyed along with the container, so you'll need to reload it. If you're using the demo project, you'll need to manualy create the database schema and load the data. You can do this by opening a command shell on the *nginx* container and running the *console* commands. Here are the exact commands:

```
# Open a command shell in the nginx container
$ docker exec -it ansible_nginx_1 /bin/bash

# Set the working directory to the web directory
$ cd /var/www/nginx

# Create the database schema
$ php bin/console doctrine:schema:create

# Load the data
php bin/console doctrine:fixtures:load --no-interaction
```
### Access the production web server

Access the web server exactly the same as before, except this time use port 8888.

### Learn about the build process

To understand more about how the `build` process works, take a look at  [ansible/main.yml](https://github.com/chouseknecht/symfony-mariadb-nginx/blob/master/ansible/main.yml). This is an Ansible playbook, which Ansible Container executes to build each of the services in our project.

<h2 id="openshift">Deploy to OpenShift</h2>

For this example we'll run a local OpenShift instance. You'll need the following to create the instance: 

- Download the [oc client](https://github.com/openshift/origin/releases/tag/v1.3.0), and add the binary to your PATH.

- If you're running Docker Engine, configure the daemon with an insecure registry parameter of 172.30.0.0/16  

    - In RHEL and Fedora, edit the /etc/sysconfig/docker file and add or uncomment the following line

        ```
        INSECURE_REGISTRY='--insecure-registry 172.30.0.0/16'
        ```
    - After editing the config, restart the Docker daemon. 

        ```
        $ sudo systemctl restart docker
        ```
- If you're using Docker Machine, you'll need to create a new instance. The following creates a new instance named *devel*

    ```
    docker-machine create -d virtualbox --engine-insecure-registry 172.30.0.0/16 --virtualbox-host-dns-resolver devel
    ```

Launch the instance:

```
$ oc cluster up
```

After the command completes, access instructions will be displayed that include the console URL along with a user account and an admin account details. For example:

```
-- Server Information ...
   OpenShift server started.
   The server is accessible via web console at:
       https://192.168.99.106:8443

   You are logged in as:
       User:     developer
       Password: developer

   To login as administrator:
       oc login -u system:admin
```

Login using the administrator account, and create a project that matches the name of your project. For example, the following creates a *symfony-mariadb-nginx* project:

```
# Login as the admin user
$ oc login https://<your Docker Host IP>:8443 -u system:admin

# Create a project with a name matching the name of our project directory
$ oc new-project symfony-mariadb-nginx
```

### Build the images

We neeed to buid a set of images for our project with the latest code deployed inside the *nginx* image. Each time you make code changes and want to deploy, you will need to run a build in order to upate the nginx image. Run the following to build the images:

```
# Set the working directory to the root of the project
$ cd symfony-mariadb-nginx

# Build the images
$ make build
```

### Push the images to the registry. 

For example purposes we'll push the images to Docker Hub. If you have a private registry, you could use that as well. See [registry overview](https://docs.openshift.org/latest/install_config/registry/index.html) for instructions on using registries with OpenShit. 

To push the images we'll use the `ansible-container push` command. If you previously logged into Docker Hub using `docker login`, then you should not need to authenticate again. If you need to authentication, you can use the *--username* and *--password* options. For more details and available options see [the *push* reference](http://docs.ansible.com/ansible-container/reference/push.html).

The following will perform the push:

```
# Set the working directory to the project root
$ cd symfony-mariadb-nginx

# Push the images 
$ ansible-container push 
```

### Generate the deployment playbook and role

Now we're ready to transform our orchestration document [ansible/container.yml](./blob/master/ansible/container.yml) into deployment instrutions for OpenShift by running the `ansible-container shipit` command to generate an Ansible playbook and role.

For our example the images are out on Docker Hub. If you're using a private registry, you'll need to use the *--pull-from* option to specify the registry URL. For `shipit` details and available options see [the shipit reference](http://docs.ansible.com/ansible-container/reference/shipit.html).

The following will build the playbook and role:

```
# Set the working directory to the project root
$ cd symfony-mariadb-nginx

# Run the shipit command, using the IP address for your registry
$ ansible-container shipit openshift
```

### Run the deployment

The above added a playbook called *shipit-openshift.yml* to the *ansible* directory. The playbook relies on the `oc` client being installed and available in the PATH, and it assumes you already authenticated, and created the project.

When you're ready to deploy, run the following:

```
# Set the working directory to the ansible directory
$ cd symfony-mariadb-nginx/ansible

# Run the playbook
$ ansible-playbook shipit-openshift.yml
```

### Access the application

Start by logging into the OpenShift console using the URL displayed when you ran `oc cluster up`. Log in using the administrator account, and select the *symfony-mariadb-nginx* project. When the dashboard comes up, you'll see two running pods:

<img src="https://github.com/chouseknecht/symfony-mariadb-nginx/blob/images/img/dashboard.png" alt="dashboard view" />


To access the application in a browser, click on the *Application* menu, and choose *Routes*. You'll see a route exposing the *nginx* service. Click on the *Hostname* to open it in a browser.

### Load the database

If you're running the demo app, you can load the sample data similar to what you did previously in the [production build step](#production-run), except this time we'll use the `oc` command. Start by getting the name of the *nginx* pod:

```
# List all pods in the project
$ oc get pods

NAME              READY     STATUS    RESTARTS   AGE
mariadb-3-3xxsf   1/1       Running   0          1h
nginx-3-gi4tj     1/1       Running   0          1h
```

Access the nginx pod, by running the `oc rsh` command followed by the name of your *nginx* pod. For example:

```
# Open a session to the pod
$ oc rsh nginx-3-gi4tj 
```

Now inside the *nginx* pod, run the following:

```
# Set the working directory to the web directory
$ cd /var/www/nginx

# Create the database schema
$ php bin/console doctrine:schema:create

# Load the data
$ php bin/console doctrine:fixtures:load --no-interaction

# Exit the container
$ exit
```

<h2 id="next">What's next?</h2>

If you followed through all of the examples, we covered a lot of ground. Under the covers we're using Ansible Container to build and manage the containers, so you'll want to use the following resources to learn more:

- [Project repo](https://github.com/ansible/ansible-container)
- [Docs Site](https://docs.ansible.com/ansible-container)

### Project configuration 

When we create the new project or the demo project, we're relying on the entrypoint script, symfony config and other files that get added into the *symfony* image during the `build` process. This gets handled in the [configure-symfony role](./tree/master/ansible/roles/configure-symfony)

### Nginx, php-fpm and supervisor

The nginx service is configured by the [configure-php-fpm role](./tree/master/ansible/roles/configure-php-fpm) as well as the [supervisord role](./tree/master/ansible/roles/supervisord) during the build process. You'll want to take a look at these roles to understand how the container is configured. 

<h2 id="contributing">Contributing</h2>

If you work with this project and find issues, please [submit an issue](https://github.com/chouseknecht/symfony-mariadb-nginx/issues). 

Pull requests are welcome. If you want to help add features and maintain the project, please feel free to jump in, and we'll review your request quickly, and help you get it merged.

<h2 id="license">License</h2>

[Apache v2](https://www.apache.org/licenses/LICENSE-2.0)

<h2 id="dependencies">Dependencies</h2>

- [chouseknecht.mariadb-container](https://galaxy.ansible.com/chouseknecht/mariadb-container)
- [chouseknecht.nginx-conainer](https://galaxy.ansible.com/chouseknecht/nginx-container)

<h2 id="author">Author</h2>

[chouseknecht](https://github.com/chouseknecht)

