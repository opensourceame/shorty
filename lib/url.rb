module Shorty
  class URL

    REGEX = /^[0-9a-zA-Z_]{6}$/

    ERROR_URL_INVALID   = 1
    ERROR_URL_EXISTS    = 2
    ERROR_CODE_INVALID  = 3
    ERROR_CODE_EXISTS   = 4


    # @param url [String] the URL to shorten
    # @param code [String] an optional code
    # @return [String, Integer] the code or an error code on failure
    def shorten(url, code = nil)

      return ERROR_URL_INVALID unless valid_url?(url)
      return ERROR_URL_EXISTS  if url_stored?(url)
      return ERROR_CODE_EXISTS if code && code_stored?(code)

      unless code.nil?

        return ERROR_CODE_INVALID unless code.match(REGEX)

        store(url, code)

        return code
      end

      code = generate_code

      store(url, code)

      code

    end

    def get(code)

      log_hit(code)
      get_code(code)

    end

    # @param code [String] the short code
    # @return [Hash] a hash of statistics
    def stats(code)

      return false unless code_stored?(code)

      data = get_code(code)

      {
          startDate:      data['ctime'],
          lastSeenDate:   data['atime'],
          redirectCoutn:  data['hits']
      }
    end

protected

    # store this mofo in Redis
    # @param url [String] the URL to shorten
    # @param code [String] the short code
    def store(url, code)

      redis.hmset("shorty:code:#{code}",
          :url,    url,
          :ctime,  Time.now,
          :atime,  Time.now
          :hits,   1
      )

      log_hit(code)

      # set a reverse key for quick lookup
      redis.set("shorty:url:#{url_hash(url)}:code", code)
    end

    def generate_code
      SecureRandom.urlsafe_base64(6)[0..5]
    end

    def url_hash(url)
      Digest::MD5.hexdigest(url)
    end

    def url_stored?(url)
      redis.exists("shorty:url:#{url_hash(url)}:code")
    end

    def code_stored?(code)
      redis.exists("shorty:code:#{code}")
    end

    def get_code(code)
      redis.hgetall("shorty:code:#{code}")
    end

    def log_hit(code)
      redis.hincrby("shorty:code:#{code}", :hits, 1)
    end

    # a very simple way to validate a URL
    def valid_url?(url)
      uri = URI.parse(url)

      uri.absolute?
    rescue
      false
    end

private

    def redis
      @redis = Redis.new(db: Sinatra::Application.environment == :development ? 15 : 1)
    end

  end
end