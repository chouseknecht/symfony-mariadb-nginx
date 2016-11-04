Role Name
=========

Configures the nginx service to run php-fpm alongside nginx, and employs supervisord as the process manager. 

You can't do that!
------------------

Well, actually, you can. Combining php-fpm with nginx gives you all the knobs and dials to manage security and process pools. Adding supervisord gives us a single process or thing to start when the container launches, and then it in turn handles the starting and juggling of nginx and php-fpm workers. It's actually quite fantastic, and I think the right thing to do. It's how we would typically do things in a VM world, so why is it suddenly not valid here?

Some might argue that php-fpm should be in a container separate from nginx. You can do that if you like, and it's perfectly fine to do so. However, I personally think that doing so makes the application more complex, and adds in a slight amount of network latency as the two services will communicate over an IP connection as opposed to Unix sockets. Imagine when it's time to scale the application, you will have to scale the nginx service independent of the php-fpm service, which means you'll need to insert a load balancing service between them, and thus add more complexity.

Requirements
------------

Assumes you have already created an nginx service with chouseknecht.nginx-container or by some other means. 


Role Variables
--------------

?? 

License
-------

Apache v2

Author Information
------------------

[@chouseknecht](https://github.com/chouseknecht)
