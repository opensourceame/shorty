require 'pry'

require_relative '../init.rb'

redis = Redis.new(db: 15)
redis.flushall
