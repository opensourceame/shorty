describe Shorty::Code do

  CODE_REGEX = /^[0-9a-zA-Z_]{6}$/

  let(:shorty) { Shorty::Code.new }

  it 'creates a specified short code' do

    result  = shorty.shorten_url('http://github.com/opensourceame', 'abc123')

    expect(result).to eq 'abc123'
  end

  it 'creates a generated short code' do

    result  = shorty.shorten_url('http://www.redhotpawn.com')

    expect(result).to match(CODE_REGEX)
  end

  it 'gets code for existing URL to increment hits' do

    result  = shorty.stats('abc123')

    expect(result).to be_a(Hash)
    expect(result['hits'].to_i).to eq 2
  end

  it 'tries to create a code for an existing URL' do

    result  = shorty.shorten_url('http://github.com/opensourceame')

    expect(result).to eq 'abc123'
  end

  it 'tries to create a code that already exists' do

    expect{
      shorty.shorten_url('http://bbcgoodfood.com', 'abc123')
    }.to raise_error('code exists')

  end

  it 'tries to shorten an invalid URL' do
    expect {
      shorty.shorten_url('eat_my_shorts', 'abc123')
    }.to raise_error(ArgumentError)
  end

  it 'tries to create an invalid short code' do
    expect{
      shorty.shorten_url('http://www.urbandictionary.com', 'iShortYouNot!')
    }.to raise_error(ArgumentError)
  end

  it 'tries to fetch a nonexistent short code' do

    expect{
      shorty.get('Where?')
    }.to raise_error(IndexError)

  end

end