puppet-sqlserver
=============

A very basic puppet module to install and configure SQL Server. Very much a work in progress

## How to build
```
bundle install --path .bundle

# Point the KITCHEN_YAML environment variable to one of the .kitchen.*.yml file at the root of this repo.

bundle exec rake acceptance:kitchen

# Each test-kitchen instance (suite + platform) is tested on its own and reported to Teamcity as a separate test.
# Failed instances are retried KITCHEN_RETRIES times: 1 by default in Teamcity, 0 locally (so a failed instance is left for you to debug).
KITCHEN_RETRIES=1 bundle exec rake acceptance:kitchen
```
