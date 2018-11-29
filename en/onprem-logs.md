Title: Log files

# Log files

Landscape generates several log files in `/var/log/landscape`:

- `update-alerts`: output of that cron job. Used to determine which computers
  are offline
- `process-alerts`: output of that cron job. Used to trigger alerts and send
  out alert email messages
- `process-profiles`: output of that cron job. Used to process upgrade profiles
- `sync_lds_releases`: output of that cron job. Used to check for new Landscape
  On-Premises releases
- `maintenance`: output of that cron job. Removes old monitoring data and
  performs other maintenance tasks
- `update_security_db`: output of that cron job. Checks for new Ubuntu Security
  Notices
- `appserver-N`: output of the application server N, where N (here and below)
  is a number that distinguishes between multiple instances that may be running
- `appserver_access-N`: access log for application server N; the application
  server handles the web-based user interface
- `message_server-N`: output of message server N; the message server handles
  communication between the clients and the server
- `message_server_access-N`: access log for message server N
- `pingserver-N`: output of pingserver N; the pingserver tracks client
  heartbeats to watch for unresponsive clients
- `pingtracker-N`: complementary log for pingserver N detailing how the
  algorithm is working
- `async-frontend-N`: log for async-frontend server N; the async front end
  delivers AJAX-style content to the web user interface
- `api-N`: log for API server N; the API services handles requests from
  landscape-api clients
- `combo-loader-N`: log for combo-loader server N, which is responsible for
  delivering CSS and JavaScript
- `job-handler-N`: log for job-handler server N; the job handler service
  controls individual back-end tasks on the server
- `package-upload-N`: output of package-upload server N, which is used in
  repository management for upload pockets, which are repositories that hold
  packages that are uploaded to them by authorized users
