# Shorty - a URL shortening API

## Installation

#### Requirements

* Ruby 2.x
* Bundler
* Redis server for storage

#### To install

```
 bundle install
 unicorn / rackup / (other rack server)
```

## Storage

Data is stored to Redis on database 1 in production and database 15 in development / test environments.

The Redis DB is flushed upon initialisation of the development environment.
 
## Tests

Simply run ```rspec``` from the root directory of the project.

