1 All the DNS A records are deleted as part of the initial build process. If a 3rd party (script maybe) or yourself navigates to your live URL whilst all A records are deleted they/you will be served an NXRecord which basically means that there is no record for that domain.
THE NXRecord seems to be cached and it may cause an issue with SSL certificate issuance. In this case, you will see an error message with NXRecord in the message body and the build process will terminate. The solution is to wait for the caching to clear so that the NXRecord is no longer being served and restart the build process. Under normal operation, this should not happen. 

2. To shutdown your infrastructure it is important not to simply shutdown the machines using a provider's GUI system or the cli tools. There's a script in the helperscripts directory called ShutdownInfrastructure.sh which you must run each time you want to shut your system down. This gives the machines a chance to clean up and so on which means that your data will be consistent.

3 If you want to change the number of webservers that are running, you need to do it by running the script in ${BUILD_HOME}/helperscripts called ModifyScaling.sh

4 If you are using cloudflare as your DNS Service provider, you need to, at a minimum, switch on 'Full SSL' and also, you need to create a page rule which directs all calls to http://www.website.com to https://www.website.com. This way, you can be sure that all your requests are being issued securly. Also, when you are in development mode, letsencrypt will issue a "testing" certificate which cloudflare will not accept in strict mode. If you drop it back down to full during development and up to strict once you are ready for production, this should allow you to make most efficient use of the certificate issuing process. 

5 Remember if you change from deploying to one DNS service and choose another, you will have to change the nameservers with the service you bought your domain names. This is called a Nameserver update and has a propagation delay of up to 48 hrs before your webproperty will be accessible through the new nameservers. 

6 Advised best practice is to rotate your ssh keys. The simplest way to do that with this toolkit is simply to set aside a maintenance window, take your deployment down and redeploy, possibly to a different cloudhost. 

7 When you are deploying an application from a baseline it can take some time for the assets to be uploaded to your datastore provider. If you terminate a deployment before the assets have been transfered, then that is obviously an issue. So, when you deploy from a baseline, you have to give ample time for your assets to be uploaded to the datastore for cross deployment asset persistence. 

8 If you want to customise the configuration of your webserver, you can easily do it by altering the scripts in

Agile-Infrastructure-Webserver-Scripts/providerscripts/webserver/configuration/*

9 If you want to change the number of webservers that are run by default, you can change the NO_WEBSERVERS variable in
Agile-Infrastructure-Autoscaler-Scripts/autoscaler/PerformScaling.sh. Always rememeber that there are cron scripts which 
configure how many webservers are running for different times of day and you can alter those to manage your compute provisions. 

10 To alter your test database configuration, you can modify the file:

 Agile-Infrastructure-Database-Scripts/providerscripts/database/singledb/mariadb/InitialiseMariaDB.sh for Maria DB
 
 and the file
 
 Agile-Infrastructure-Database-Scripts/providerscripts/database/singledb/postgres/InitialisePostgresDB.sh for Postgres
 
11 If you want to monitor your application uptime, I recommend uptime robot www.uptimerobot.com
 You may have to whitelist the uptimerobot ips if you have a firewall, they can be found here: https://uptimerobot.com/locations

12. If you are using s3fs for your shared storage, then, if you delete the buckets using the cloudhost provider's gui system or the s3cmd tool there tends to be a period of time with some providers when buckets of the same name cannot be created again. If you run the scripts during this period and they require the same bucket name as a bucket that you have recently deleted for shared storage, you will get unpredictable behaviour. If you wait till the grace period expires, then, you will be able to complete the execution of the scripts successfully.  

