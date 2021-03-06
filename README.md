# README #

### ASSOCIATED WEBSITE: www.codebreakers.uk

This toolkit automates the deployment of LEMP/LAMP stacks with built in scalability for various CMS systems (currently Wordpress, Joomla, Moodle, Drupal) starting with nothing and building out from there. This is close to being a PAAS solution meaning that purely through parameter configuration, you can have a fully deployed application infrastructure that can scale with consistent security practices built in. Some of the disadvantages of PAAS solutions are: a lack of operational control and features. Using this solution, you have, what is effectively a PAAS solution but, with total control of your servers and databases if you choose to or need to. For my needs this was the best of both worlds because through automation, I avoid the repeated work of server configuration and at the same time retain full control over my deployed environment. This solution is extensible and reusable meaning developers can easily extend (and share their work) for their use cases. 

-----

### IMPORTANT 

There are various configurations of deployment using this toolkit. Make sure you test what costs will be incurred depending on the scale of the deployment you are making. Different providers have different cost metrics and so, it's possible that one provider's operational costs will be different to another for a similar configuration. Costs profiles vary depending upon what configuration settings you have chosen. For example, if you chose a datastore in a different region to your VPS systems, which this toolkit does not preclude you from doing, you may unwittingly incur considerable costs. 

-----

### QUICK START

To get started as quickly as possible before going into more depth, you can use one of these methods: [Template Overrides](https://github.com/agile-deployer/agile-infrastructure-build-client-scripts/blob/master/templatedconfigurations/templateoverrides.md)

--------

The vision for this toolkit is to have a well tested limited scope core for deploying web properties and CMS based systems.
The "core" currently supports Joomla, Wordpress, Moodle and Drupal. The "next" phase is to have more eyeballs on it and broader usage, it's only been me testing it so far. The idea is that other developers can easily fork the repositories for The Agile Deployment Toolkit and develop additional capabilities such as support for additional VPS service providers, additional CMS systems, email providers and so on. The vision is that these extensions will not be merged back into the core, but, rather, can be kept as separate extension repos where deployers can choose the particular fork for their deployment needs. For example, if someone were to fork this and extend it to support Google Cloud and a deployer wanted to deploy to Google Cloud, then, they would use a fork which supports Google Cloud which the core currently doesn't. In this way, the core can be kept with a small, well tested, well maintained footprint making for a reliable experience. 
Clearly, there's a plethora of deploymemt options out there if you want a CMS system, and, this is another one. It should fit you well if you want full access to the Linux VPS systems that your application is running on and if you don't want to necessarily be bothered with manual software installs and configurations. 
There's many combinations of test scenarios with this software. I am one developer, I have tested it as well as I can, but, will have to rely on feedback. If you find any problems please report them using the forum on www.codebreakers.uk, thanks in advance. 

-----

### OBJECTIVE

Personally, I like to have full control over the software on my VPS systems. Using traditional methods, this meant repeatedly manually installing and security hardening each server as evidenced by the many installation guides available online.
So, I decided to start scipting, with the aim of automating some of the processes and it is out of that scripting that this toolkit arose.
What it has become is essentially an automated way of deploying which is extensible, has consistent security practices (I am open to recommendations about how the setup can be made even more secure).
I think I have used good software design processes in terms of encapsulation and making the code easily modifiable and extensible.
The scripts are made out of nothing but the Linux shell. This means that everything can be understood as shell based processes. 
The aim of this toolkit it to provide a consistent way to deploy the same customised CMS application multiple times for example to town A, town B and so on. This is the Agile Deployment Toolkit. In other words, the exact same process (although with possibly  a different configuration) should be used to deploy for town B as it is for town A.

-----

### REQUIREMENTS

To use this toolkit you will need to setup accounts with the following providers supported within the core:

1) For VPS services, one of - Digital Ocean, Linode, Exoscale, Vultr, AWS
2) For Email services, one of - Amazon SES, Gmail or Sendpulse
3) For git based services, one of - Bitbucket, Github or Gitlab
4) For DNS services, one of - Cloudflare, Rackspace or Digital Ocean (note, clourflare has security features which are absent from naked dns services). 
5) For object store services, one of - Digital Ocean Spaces, Exoscale Object Store, Linode Object Store, Vultr Object Store or Amazon S3
6) From these providers AWS and Digital Ocean currenlty support managed DB systems but other providers are projected to make offerings of managed DB solutions as well in the near future

Clearly, you will likely want to chose the same provider for your Object storage service and VPS services and so on, but, there's nothing stopping you, for example, deploying on Linode for your VPS systems and using Digital Ocan Spaces for your object store service, although you won't be wanting your object storage geographically distant from where your VPS systems are running. 

-----

### MOTIVATION

When you use shared hosting, for example, some php settings are under the control of the hosting provider which can be cumbersome as you have to contact them every time your application needs a configuration change. Vanilla VPS systems are great, but you still have to setup all the software and that can be error prone and not easily reproduced. Building off pre-built images is another way where the server software setup is baked into the image and all you have to do is deploy it. And then of course there is docker and things like that (which I have no experience of).
In my case I found that all of these solutions were not quite what I wanted. If you build from a prebuilt image for example, OK, you have your server configured for that machine, but what about if you want some architectural nicities as well? So, my solution includes some architectural design as well as a way of automatically building the servers as required. It's a "low barrier to entry" solution. 
Another way that I have tried to innovate is that you can develop an application, a social network, say, maybe in Joomla or Drupal and from that, you can baseline it when you have finished it to "stable" standard. From that baseline, if you opensource the code on github, bitbucket or gitlab, then others can easily deploy your application as their own. This can have several time saving advantages as it might not be necessary to build an application from scratch if you can find one that someone else has built that meets your requirements or maybe meets your requirements with a little more work.
The only fly in the ointment is licensing. If an application is built with commercial extensions, then, it is possible they will only be licensed to work on one domain or only licensed to a particular person or entity that purchased it. So, people deploying applications that others have developed will have to be aware of what the licensing is for the constituent parts  or components and purchase, as necessary, their own licenses from the vendor(s) of the components. 

-----

### THE SPECIFICS

The Agile Deployment Toolkit is designed to be modifiable and extensible, for example, you can plugin which database you want to use (currently supported are mysql, mariadb and postgres) but you could extend the scripts to support Mongo DB or some other DB type also. It is also architected to use DBaaS so if you want to you can use a DBaaS in the cloud and you don't have to worry about anything then to do with DB stuff and its configuration as the service provider has got you covered. 
One of the challenges of architecting with multiple webservers is how to share user assets between the webservers so that the new asset updates are available to all the webservers concurrently. Some people say to rsync between the servers but I chose to have cloud based asset storage which is remote  mounted to, and cached by, the each webserver.
Shared configuration files and settings are securely stored in the object store and mounted using a tool (s3fs) to each of our servers are are shared between the machines with resilence built in should there be networking issues. 

As far as the build procedure is concerned the normal modus operandi is to have a dedicated VPS build machine in a cloudhost of your choice and to pull down the build client scripts from the git repository. 

-----

### THE FULL BUILD

You must use a dedicated linux machine for your build processes as the build will add and remove software which you may not want to happen if you are using your linux machine for other purposes. 
#### YOU MUST USE A DEDICATED BUILD MACHINE
So, to run this build kit, you need a vanilla (but secured) Ubuntu server 19.04 or later or a (vanilla but secured) debian 9 server or up. 
Maybe more flavours of linux will be supported later. So, spin up a vanilla instance of ubuntu or debian your favourite cloudhost and then, having made sure it is secure, ssh onto it (if you are on windows, using putty - making sure putty is not set to drop long lasting connections) and start the build process for your deployment.
If you don't want to pay for a dedicated build machine in the cloud, you could setup a USB image of ubuntu or debian which has persistent storage and use your local machine for running your builds. It is advised that you use an OS image dedicated for this process. 
I personally use MX Linux https://mxlinux.org/ if I want to run my build processes from a USB on my local laptop. 

You need to clone this build kit onto your new build server.

Then you can start the process by running:

##### ${BUILD_HOME}/AgileDeploymentToolkit.sh 

Where build home is the directory you where you placed the build scripts.

Because you have a dedicated 'build machine' in the cloud which doesn't have any other purpose, you can run this build script as root on that machine. I know it's lazy like that, but, by having a dedicated machine it makes it OK.  

The build process is guided and it is essential to put in sane information when prompted for it to succeed. The build scripts do as much checking for erroneous inputs as they can, but not everything can be checked and validated and erroneous inputs will have 
unexpected behaviours downstream in the build process. The build script will deploy various server types to your selected cloudhost and when completed, you will be able to navigate to you application through your browser.

Currently, these repos are private, but, will be made public. Whilst they are private, you will need to request read access to the 
##### Agile Infrastructure Webserver Scripts,
##### Agile Infrastructure Autoscaler Scripts,
##### Agile Infrastructure Database Scripts

Edit: (They have now been made public)

Here are two instructional or demo videos for how to set up your build server and how to run an example build process. I think you will definitely want to watch these videos before you run a build of your own.

[Agile Deployment Toolkit Build Server Setup Example](https://www.youtube.com/watch?v=ONp_QuPxcsc)


[Sample Build Process Agile Deployment Toolkit](https://www.youtube.com/watch?v=mXpIRB_7O_M&t=80s)

-----

### THE EXPEDITED BUILD

##### ${BUILD_HOME}/ExpeditedAgileDeploymentToolkit.sh

-----

### THE CONCLUSION

So, the idea is for people who want a CMS application or a website of some sort, their systems usually have basically the same requirements, a database, a webserver, loadbalacing and enough disk space for the assets to be stored for their application. I use the DNS systems to facilitate load balancing between the webserves which they do in a round robin fashion. I structured the scripts in such a way that they are easy to maintain and extend and that's part of what this is about. Providing a deployment framework which automates a lot of the grunt work and still gives the deployer full access to customise their servers. You don't have to learn anything except how to run the scripts so it has a lower experience threshold than some other automated solutions. At the same time, you can get in there and easily tune your servers exactly as you want them. 

So, that's a mile high view. I should say that I would consider this to be beta because there's a proliferation of test scenarios depending upon what combination of software you are testing for. There's lots of different combinations lets say and whilst I have done my best I would be grateful for any feedback regarding any unnoticed oversights. 
