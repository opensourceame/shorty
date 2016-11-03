

describe Shorty::URL do

  describe 'shorten URL' do

    it 'create a specified short code' do

      shorty  = Shorty::URL.new
      result  = shorty.shorten('http://github.com/opensourcame', 'abc123')

      expect(result).to eq 'abc123'
    end

    it 'create a generated short code' do

      shorty  = Shorty::URL.new
      result  = shorty.shorten('http://github.com/opensourcame')

      expect(result).to match(/^[0-9a-zA-Z_]{6}$/)
    end

    it 'gets code for existing URL to increment hits' do

      shorty  = Shorty::URL.new
      result  = shorty.stats('abc123')

      expect(result).to be_a?(Hash)
    end

    it 'tries to create a code for an existing URL' do

      shorty  = Shorty::URL.new
      result  = shorty.shorten('http://github.com/opensourcame')

      expect(result).to be false
    end

    it 'tries to create a code that already exists' do

      shorty  = Shorty::URL.new
      result  = shorty.shorten('http://bbcgoodfood.com', 'abc123')

      expect(result).to be false
    end

    it 'tries to shorten an invalid URL' do

      shorty  = Shorty::URL.new
      result  = shorty.shorten('eat_my_shorts', 'abc123')

      expect(result).to be false
    end

    it 'tries to specify an invalid short code' do

      shorty  = Shorty::URL.new
      result  = shorty.shorten('http://www.urbandictionary.com', 'iShortYouNot!')

      expect(result).to be false
    end

  end
end