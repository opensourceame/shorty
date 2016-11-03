require_relative 'init'

configure do
  set :logging, Logger::DEBUG
end

$stdout.sync = true
$stderr.sync = true

use Shorty::API::Response

routes = Rack::Mount::RouteSet.new do |set|
  set.add_route Shorty::Endpoints::Shorten,         :path_info => %r{^/shorten}
end

puts "*** Starting Shorty ***"

run routes
