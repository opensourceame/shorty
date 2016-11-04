# Shorty - a URL shortening API

## Installation

* bundle install
* unicorn

## Storage

Data is stored to Redis on database 1 in production and database 15 in development / test environments.
 
## Tests

Simply run *rspec* from the root directory of the project.
The Redis DB is flushed before tests are run.

