module Shorty
  class Code

    CODE_REGEX          = /^[0-9a-zA-Z_]{6}$/
    KEY_EXPIRE_SECONDS  = 31556926               # one year

    # @param url [String] the URL to shorten
    # @param code [String] an optional code
    # @return [Shorty::Code]
    def shorten_url(url = nil, code = nil)

      raise ArgumentError, 'URL must be specified' unless url
      raise ArgumentError, 'invalid URL' unless valid_url?(url)

      if url_stored?(url)

        shortcode = fetch_code_for_url(url)

        # if they've specified a code and it's different to the stored one then raise an error
        raise StandardError, 'different code stord for this URL' if code && (code != shortcode)

        # otherwise send them the code we created previously
        return shortcode

      end

      if code_stored?(code)
        raise StandardError, 'code exists'
      end

      unless code.nil?

        raise ArgumentError, 'invalid code' unless valid_shortcode?(code)

        store(url, code)

        return code
      end

      code = generate_code

      store(url, code)

      code

    end

    # @param code [String] the shortcode
    # @return [String] the URL related to the shortcode
    def get(code)

      raise IndexError, 'code not found' unless code_stored?(code)

      log_hit(code)
      fetch_data_for_code(code)

    end

    # @param code [String] the shortcode
    # @return [Hash] a hash of statistics
    def stats(code)

      raise IndexError, 'code not found' unless code_stored?(code)

      fetch_data_for_code(code)

    end

    def valid_shortcode?(code)
      code.match(CODE_REGEX)
    end

    # a very simple way to validate a URL
    def valid_url?(url)
      uri = URI.parse(url)

      uri.absolute?
    rescue
      false
    end

    def url_stored?(url)
      redis.exists("shorty:url:#{url_hash(url)}:code")
    end

    def code_stored?(code)
      redis.exists("shorty:code:#{code}")
    end

    protected

    # store this mofo in Redis
    # @param url [String] the URL to shorten
    # @param code [String] the short code
    def store(url, code)

      redis.hmset("shorty:code:#{code}",
                  :url,    url,
                  :ctime,  Time.now,
                  :atime,  Time.now,
                  :hits,   1
      )

      log_hit(code)

      key = "shorty:url:#{url_hash(url)}:code"

      # set a reverse key for quick lookup
      redis.set(key, code)
      redis.expire(key, KEY_EXPIRE_SECONDS)
    end

    def generate_code
      SecureRandom.urlsafe_base64(4).gsub('-', '_')
    end

    def url_hash(url)
      Digest::SHA384.hexdigest(url)
    end

    def fetch_data_for_code(code)
      redis.hgetall("shorty:code:#{code}")
    end

    def fetch_code_for_url(url)
      redis.get("shorty:url:#{url_hash(url)}:code")
    end

    def log_hit(code)
      redis.hincrby("shorty:code:#{code}", :hits,  1)
      redis.hset("shorty:code:#{code}",    :atime, Time.now)
    end

    private

    def redis
      @redis = Redis.new(db: Sinatra::Application.environment == :development ? 15 : 1)
    end

  end
end