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

### Why Redis?
 
I'm making the assumption here that these short codes are to be used for cases like a short URL for a map location for a festival.
Redis is ideal for quick lookups on keys and incrementing counters.

With 5 elements per hash per code a Redis server will use approximately 100MB RAM for 1 million short codes,
thus a cheap server (€20/month) could store tens of millions of short codes.
 
Keys automatically expire after a year. (Changeable by editing ```Shorty::Code::EXPIRE_SECONDS```)
 
## Tests

Simply run ```rspec``` from the root directory of the project.

