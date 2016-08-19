Version 0.4.0

* selectable bootstrap method allowing to keep chef client private keys in Foreman
* supporting host rebuilds and environment configuration via provisioning template
* restored compatibility with Foreman 1.13 which is now minimal required version
* fixed JS for environment control after host form refresh
* fixed migration to work also with MySQL

Version 0.3.1

* fixed rendering issue with safe_mode enabled
* fixed an issue with environment select box being empty

Version 0.3.0

* configuration of Chef environment for a host
* compatibility with Foreman 1.11+ (Rails 4)

Version 0.2.0
* change internals so Foreman 1.9+ is required
* improved Windows facts parsing
* fixed an issue of importing new OS based on facts

Version 0.1.7
* fixed failure when no OS attributes present in fact upload
* restored compatibility with upcoming Foreman 1.9

Version 0.1.6
* relax deface version restriction

Version 0.1.5
* relax foreman-tasks version restriction

Version 0.1.4
* fix operating system facts parsing which failed if no lsb info was present
* better error handling when deletion of node fails because of chef unavailability
* fix gem based installation startup

Version 0.1.3
* parse attributes to correctly assign OS, Domain, Model, Architecture
* parse attributes to create and update host interfaces
* builtin Chef 12 support (validator name configurable, chef server cert installation)
* fixed race condition on attributes import

Version 0.1.2
* provide default config templates and global parameters

Version 0.1.1
* fixes issues with reloading of modules (affects probably only dev setup)

Version 0.1.0
* smart proxy feature renamed to "Chef"
* active communication with chef-server, deletes nodes and clients
* allows chef proxy specification per hostgroup and host

Version 0.0.4
* relicense to GPL-3

Version 0.0.3
* compatibility fixes

Version 0.0.1 - 0.0.2
* initial version that adds own fact name type and provides own importer
