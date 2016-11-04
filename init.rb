require 'sinatra'
require 'rack/mount'
require 'logger'
require 'redis'
require 'securerandom'
require 'json'

require_relative 'helpers/request'
require_relative 'helpers/response'

require_relative 'lib/url.rb'

require_relative 'app/shorty.rb'

if Sinatra::Application.environment == :development

  # debugging goodness :)
  require 'pry'

  redis = Redis.new(db: 15)
  redis.flushall
end
