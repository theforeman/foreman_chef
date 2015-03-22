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
