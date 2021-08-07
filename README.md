# puppet-lab
Puppet lab to test out nginx infra

## Objective:

This project is an attempt to create the following infrastructure case using puppet:

* Create a proxy to redirect requests for https://domain.com to 10.10.10.10 and redirect requests for https://domain.com/resource to 20.20.20.20.

* Create a forward proxy to log HTTP requests going from the internal network to the Internet including: request protocol, remote IP and time take to serve the request.

* (Optional) Implement a proxy health check.


## Prerequisites:

This project has been developed with puppet v6.16.1.

To be able to create the infra, you need to have installed the forge module: nginx - Puppet NGINX management module by Vox Pupuli,
the one used for this project has been v3.2.0 latest as of 06/08/2021.

The nginx module, has a soft dependency on another forge module: puppetlabs/apt, the one used for this project has been v8.1.0 latest as of 06/08/2021.

to install this modules in puppet:

`puppet module install puppetlabs-apt --version 8.1.0`

`puppet module install puppet-nginx --version 3.2.0`


## Description:

The structure of this project is simple, it contains this readme file, and a folder with the puppet manifests.

```
	README
	+-- manifests
		  init.pp
		  nginx.pp
		  proxy.pp
```
The puppet manifests must go into your puppet server's desired environment, for example:

`/etc/puppetlabs/code/environments/production/modules`


## Installation:

The first step (proxy) will be installed on the client defined as "puppetclient", and its defined in the nginx.pp manifest.

The second step (fw proxy) will be installed on the server defined as "puppet", ans it's defined in the proxy.pp manifest.


The installation will be done on the puppet client named "puppetclient", change this definition to the client that you want
to install into, by mofifying the first line of nginx.pp or proxy.pp modules accordingly:

`node 'puppetclient'{`

The SSL certs must be put on the folder /etc/nginx/ssl of the client or server, to create self-signed certs for a test run:

`sudo mkdir -p /etc/nginx/ssl/`

`sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/ssl/nginx.key -out /etc/nginx/ssl/nginx.crt`

To trigger the installation process from the client, we have to run the puppet agent sync:

`sudo /opt/puppetlabs/bin/puppet agent --test`

To trigger the installation process from the server, we have to run the puppet apply cmd:

`sudo puppet apply /etc/puppetlabs/code/environments/production/modules/proxy.pp`

Note: you can run it with the "--noop" flag to run first a dry-run apply cmd.


## Tests:

To test the client nginx environment, we can do the following:

1.- define domain.com locally in our client /etc/hosts to bypass DNS resolution:

`echo "$(facter ipaddress)  domain.com" >> /etc/hosts`

2.- monitor nginx access logs for our domain:

`tail -f /var/log/nginx/ssl-domain.com.access.log`

3.- launch a few requests via curl:

`for i in 1 2 3 4 5; do curl -k https://domain.com/ -v -m1; curl -k https://domain.com/resource -v -m1; done`


