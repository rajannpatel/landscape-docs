
# Managing Landscape


## Prerequisites

You can install Landscape Dedicated Server (LDS) on any server with a dual-
core processor running at 2.0GHz or higher, at least 4GB of RAM, and 5GB of
disk space. The operating system must be Ubuntu Server 12.04 LTS x86_64 or
higher. You must also have PostgreSQL installed and network ports 80/tcp
(http) and 443/tcp (https) open. You can optionally open port 22/tcp (ssh) as
well for general server maintenance.

## Installing

Refer to the [Recommended
Deployment](https://help.landscape.canonical.com/LDS/RecommendedDeployment)
guide in the Landscape wiki for all the information you need to install,
configure, and start Landscape and the dependent services it relies on.

## Upgrading Landscape

The process of upgrading an installed version of Landscape is [documented in
the Landscape
wiki](https://help.landscape.canonical.com/LDS/ReleaseNotes#Upgrading).

## Backing up and restoring

Landscape uses several PostgreSQL databases and needs to keep them consistent.
For example, if you remove a computer from Landscape management, more than one
database needs to be updated. Running a utility like `pg_dumpall` won't
guarantee the consistency of the backup, because while the dump process does
lock all tables in the database being backed up, it doesn't care about other
databases. The result will likely be an inconsistent backup.

Instead, you should perform hot backups by using write-ahead log files from
PostgreSQL and/or filesystem snapshots in order to take a consistent image of
all the databases at a given time, or, if you can afford some down time, run
offline backups. To run offline backups, disable the Landscape service and run
a normal backup with `pg_dump` or `pg_dumpall`. Offline backup can take just a
few minutes for databases at smaller sites, or about half an hour for a
database with several thousand computers. Bear in mind that Landscape can be
deployed using several servers, so when you are taking the offline backup
route, remember to disable all the Landscape services on all server machines.
See the
[PostgreSQL documentation on backup andrestore](http://www.postgresql.org/docs/9.1/interactive/backup.html) 
for detailed instructions.

In addition to the Landscape databases, make sure you back up certain
additional important files:

  * `/etc/landscape`: configuration files and the LDS license 

  * `/etc/default/landscape-server`: file to configure which services will start on this machine

  * `/var/lib/landscape/hash-id-databases`: these files are recreated by a weekly cron job, which can take several minutes to run, so backing them up can save time

  * `/etc/apache2/sites-available/`: the Landscape Apache vhost configuration file, usually named after the fully qualified domain name of the server

  * `/etc/ssl/certs/`: the Landscape server X509 certificate

  * `/etc/ssl/private/`: the Landscape server X509 key file

  * `/etc/ssl/certs/landscape_server_ca.crt`: if in use, this is the CA file for the internal CA used to issue the Landscape server certificates

  * `/etc/postgresql/8.4/main/`: PostgreSQL configuration files - in particular, postgresql.conf for tuning and pg_hba.conf for access rules. These files may be in a separate host, dedicated to the database. Use subdirectory 9.1 for PostgreSQL version 9.1, etc.

  * `/var/log/landscape`: all LDS log files

## Log files

Landscape generates several log files in `/var/log/landscape`:

  * `update-alerts`: output of that cron job. Used to determine which computers are offline

  * `process-alerts`: output of that cron job. Used to trigger alerts and send out alert email messages

  * `process-profiles`: output of that cron job. Used to process upgrade profiles

  * `sync_lds_releases`: output of that cron job. Used to check for new LDS releases

  * `maintenance`: output of that cron job. Removes old monitoring data and performs other maintenance tasks

  * `update_security_db`: output of that cron job. Checks for new Ubuntu Security Notices

  * `appserver-N`: output of the application server N, where N (here and below) is a number that distinguishes between multiple instances that may be running

  * `appserver_access-N`: access log for application server N; the application server handles the web-based user interface

  * `message_server-N`: output of message server N; the message server handles communication between the clients and the server

  * `message_server_access-N`: access log for message server N

  * `pingserver-N`: output of pingserver N; the pingserver tracks client heartbeats to watch for unresponsive clients

  * `pingtracker-N`: complementary log for pingserver N detailing how the algorithm is working

  * `async-frontend-N`: log for async-frontend server N; the async front end delivers AJAX-style content to the web user interface

  * `api-N`: log for API server N; the API services handles requests from landscape-api clients

  * `combo-loader-N`: log for combo-loader server N, which is responsible for delivering CSS and JavaScript

  * `job-handler-N`: log for job-handler server N; the job handler service controls individual back-end tasks on the server

  * `package-upload-N`: output of package-upload server N, which is used in repository management for upload pockets, which are repositories that hold packages that are uploaded to them by authorized users



