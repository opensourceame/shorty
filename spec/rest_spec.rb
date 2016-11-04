require 'rack/test'
require_relative '../init'

describe 'Shorty API' do

  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it "gets a code" do
    get '/abc123'
binding.pry
    expect(last_response).to be_ok
    expect(last_response.body).to eq('Hello World')
  end
end