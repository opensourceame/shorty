require_relative 'init'

configure do
  set :logging, Logger::DEBUG
end

$stdout.sync = true
$stderr.sync = true

run Shorty::App