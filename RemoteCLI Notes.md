# Remote CLI

## Key points

* Written in C#
* Start with the Windows interface (WPF?) and possibly later write a Mono / GTK# one for Linux and macOS.
* Ability to run as a taskbar icon (hidden form) for scheduling reasons

## Overview / technology 

* Site definitions and scheduling information stored with the storage adapter.
* Support HTTP and HTTPS connections with the possibility for a custom CA root (or do we have to trust Windows just because...?)
* GUI and engine are separate, just like in eXtract Wizard.

## Storage

* It needs an abstraction layer .
* We store and retrieve one thing: site definitions.
* We can have different backends, e.g. SQL Server, SQLite etc, depending on the platform.

## GUI notes

* We need two levels of GUI separation. Engine talks to a router which talks to the GUI abstraction layer which renders things.
* The router listens to many engine instances. Each engine instance has a label.
* The router receives events from GUI abstraction which tell it which is the active engine label.
* Each engine instance fires events. These events are listened to by the router.
* Depending on what the router is being told to listen to, it routes the appropriate events to the GUI abstraction layer, or ignores them.
* The GUI abstraction layer figures out how to present the information coming through in the events, in a platform-specific way.
* Inversely, when the GUI absrtaction layer receives user events it sends them to the router with the appropriate engine tag and the router routes them to the engine instance.

## Site definitions

* Each site definition carries information for the profile to use, download options etc
* For HTTPS sites we can define a custom CA root or a pinned SSL certificate. Useful for certificate pinning OR for dealing with self-signed HTTPS certificates.
* A dialog interface is required: we open the dialog against a site definition onject and it returns the (edited) site defition object.

## Downloads

* Each backup can have an optional download step.
* The only download options are HTTP and chunked.
* HTTP is single part download through the API. May break on some servers.
* Chunked lets you download the backup archive in smaller chunks. Default chunk: 50M. Defined in 1M increments from 1M to 2047M (values compatible with PHP).
* The download will only run if the backup completes successfully (with or without warnings).
* The download will fail if the backup is immediately marked as obsolete / remote or, of course, it failed to complete.

## Scheduling

* Use the CRON notation: minute, hour, day of the month, month, day of the week.
* The minute, hour, day of the month, month fields allow either a numeric value or an "every X" entry.
* Each time we evaluate the schedule we store the "Not After" and "Not before" times.
* "After" is the last successfully run scheduling cycle. The first time we create a schedule this is the current date/time to prevent the scheduler from running prematurely. 
* "Not before" is the next scheduling cycle.
* If we are past the "Not before" time evaluate the next scheduled time, update the database and run the scheduled task.
* Scheduling evaluation runs every 30 seconds in a background thread.

## Logging

* All actions can be logged
* Per-site log file
* Maybe we can also use the system log...?