
require 'rack/test'
# require_relative '../init'

describe 'Shorty API' do

  include Rack::Test::Methods

  LONG_URL = 'http://www.thelongestdomainnameintheworldandthensomeandthensomemoreandmore.com'

  def app
     Shorty::App
  end

  it 'creates a shortcode' do
    post '/shorten', {
        url:        LONG_URL,
        shortcode:  'long2B',
    }

    expect(last_response.status).to eq 201
  end

  it "gets a code" do

    get '/long2B'

    expect(last_response.status).to eq 302
    expect(last_response.headers['Location']).to eq LONG_URL

  end

  it 'gets stats for a code' do

    get '/long2B/stats'

    expect(last_response.status).to eq 200

    data = JSON.parse(last_response.body)

    expect(data['redirectCount']).to eq 3

  end

  it "gets an invalid code" do

    get '/NotThere'

    expect(last_response.status).to eq 404

  end

  it 'tries to create an existing shortcode' do

    post '/shorten', {
        url:        LONG_URL + '/breakme',
        shortcode:  'long2B',
    }

    expect(last_response.status).to eq 409
  end


end