Backupish
=========

A bash script to create backups of directories and mysql databases. Optionally upload to dropbox.

## How to use

* Copy `config.sh.ini` to `config.sh` and fill it with your settings
* Run `backup.sh` 

## Dropbox configuration

Running the script for the fist time with dropbox enabled will prompt for the dropbox configuration. When finished, run the script once again to see it in action.

Requirements:

* zip command
* mysqldump command
