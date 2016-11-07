require 'rack/test'

describe 'Shorty API' do

  include Rack::Test::Methods

  LONG_URL = 'http://www.thelongestdomainnameintheworldandthensomeandthensomemoreandmore.com'

  def app
     Shorty::App
  end

  it 'creates a specified shortcode' do
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

  it 'creates a generate shortcode' do
    post '/shorten', {
        url:        LONG_URL,
    }

    expect(last_response.status).to eq 201
  end

  it "gets an invalid code" do

    get '/NotThere'

    expect(last_response.status).to eq 404

  end

  it 'tries to shorten a missing URL' do

    post '/shorten', {
        shortcode:  'shortn',
    }

    expect(last_response.status).to eq 400

  end

  it 'tries to create an invalid shortcode' do

    post '/shorten', {
        url:        LONG_URL + '/invalid',
        shortcode:  'cannot-do-this',
    }

    expect(last_response.status).to eq 422
  end

  it 'tries to create an existing shortcode' do

    post '/shorten', {
        url:        LONG_URL,
        shortcode:  'InLieu',
    }

    expect(last_response.status).to eq 200

    data = JSON.parse(last_response.body)

    # match the shortcode that was previously assigned to this URL
    expect(data['shortcode']).to eq 'long2B'

  end


end