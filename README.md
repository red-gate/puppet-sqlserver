puppet-sqlserver
=============

A very basic puppet module to install and configure SQL Server. Very much a work in progress

## How to build
```
bundle install --path .bundle

# Point the KITCHEN_YAML environment variable to one of the .kitchen.*.yml file at the root of this repo.

bundle exec rake acceptance:kitchen
```
