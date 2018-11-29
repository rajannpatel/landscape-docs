Title: Backing up and restoring

# Backing up and restoring

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

In addition to the Landscape databases, make sure you back up certain
additional important files:

- `/etc/landscape`: configuration files and the Landscape On-Premises license 
- `/etc/default/landscape-server`: file to configure which services will start on this machine
- `/var/lib/landscape/hash-id-databases`: these files are recreated by a weekly
  cron job, which can take several minutes to run, so backing them up can save
  time
- `/etc/apache2/sites-available/`: the Landscape Apache vhost configuration
  file, usually named after the fully qualified domain name of the server
- `/etc/ssl/certs/`: the Landscape server X509 certificate
- `/etc/ssl/private/`: the Landscape server X509 key file
- `/etc/ssl/certs/landscape_server_ca.crt`: if in use, this is the CA file for
  the internal CA used to issue the Landscape server certificates
- `/etc/postgresql/8.4/main/`: PostgreSQL configuration files - in particular,
  postgresql.conf for tuning and pg_hba.conf for access rules. These files may
  be in a separate host, dedicated to the database. Use subdirectory 9.1 for
  PostgreSQL version 9.1, etc.
- `/var/log/landscape`: all Landscape On-Premises log files


