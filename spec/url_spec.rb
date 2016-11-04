describe Shorty::URL do

  it 'creates a specified short code' do

    shorty  = Shorty::URL.new
    result  = shorty.shorten('http://github.com/opensourcame', 'abc123')

    expect(result).to eq 'abc123'
  end

  it 'creates a generated short code' do

    shorty  = Shorty::URL.new
    result  = shorty.shorten('http://www.redhotpawn.com/')

    expect(result).to match(/^[0-9a-zA-Z_]{6}$/)
  end

  it 'gets code for existing URL to increment hits' do

    shorty  = Shorty::URL.new
    result  = shorty.stats('abc123')

    expect(result).to be_a(Hash)
    expect(result['hits'].to_i).to eq 2
  end

  it 'tries to create a code for an existing URL' do

    shorty  = Shorty::URL.new
    result  = shorty.shorten('http://github.com/opensourcame')

    expect(result).to eq Shorty::URL::ERROR_URL_EXISTS
  end

  it 'tries to create a code that already exists' do

    shorty  = Shorty::URL.new
    result  = shorty.shorten('http://bbcgoodfood.com', 'abc123')

    expect(result).to eq Shorty::URL::ERROR_CODE_EXISTS
  end

  it 'tries to shorten an invalid URL' do

    shorty  = Shorty::URL.new
    result  = shorty.shorten('eat_my_shorts', 'abc123')

    expect(result).to eq Shorty::URL::ERROR_URL_INVALID
  end

  it 'tries to create an invalid short code' do

    shorty  = Shorty::URL.new
    result  = shorty.shorten('http://www.urbandictionary.com', 'iShortYouNot!')

    expect(result).to eq Shorty::URL::ERROR_CODE_INVALID
  end

  it 'tries to fetch a nonexistent short code' do

    shorty  = Shorty::URL.new
    result  = shorty.get('Where?')

    expect(result).to eq Shorty::URL::ERROR_CODE_NOT_FOUND
  end

end