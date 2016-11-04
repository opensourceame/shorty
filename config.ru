require_relative 'init'

configure do
  set :logging, Logger::DEBUG
end

$stdout.sync = true
$stderr.sync = true

# use Shorty::API::Response

# routes = Rack::Mount::RouteSet.new do |set|
#   set.add_route Shorty::Endpoints::Shorten
# end
#
# puts "*** Starting Shorty ***"
# binding.pry
# run routes

run Shorty::App