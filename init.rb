require 'sinatra'
require 'rack/mount'
require 'logger'
require 'redis'
require 'securerandom'
require 'json'
require 'pry'             if Sinatra::Application.environment == :development

require_relative 'helpers/request'
require_relative 'helpers/response'

require_relative 'lib/url.rb'

require_relative 'app/shorty.rb'

if Sinatra::Application.environment == :development
  redis = Redis.new(db: 15)
  redis.flushall
end
