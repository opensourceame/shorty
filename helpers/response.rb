module Sinatra
  class Response

    attr_accessor :data, :errors, :logger

    def initialize
      @data     = {}
      @errors   = []
      @logger   = nil
      super
    end

    def data?
      return ! @data.empty?
    end

    def add_data(response_data)
      @data.merge!(response_data)
      self
    end

    def set_data(response_data)
      @data = response_data
      self
    end

    def add_error(messages)

      messages = [ messages ] if messages.is_a?(String)

      for message in messages
        message = message.downcase
        # logger.warn 'error: ' + message
        @errors.push(message)
      end

      return @errors

    end

    def errors?
      return ! @errors.empty?
    end

    def fail(error_messages = [], status_code = 400)

      add_error(error_messages) unless error_messages.empty?

      self.status  = status_code

      throw :halt, self
    end

    def get_data
      if @data.is_a?(Object) and ! errors?
        return @data
      end

      return_data           = {}
      return_data['errors'] = @errors if errors?
      return_data.merge!(@data)

      return_data
    end

    def finish
      if data? || errors?
        return [ status, headers, [ get_data.to_json ] ]
      end

      # backwards compatibility for endpoints that do not return a rack response object
      return [ status, headers, body ]

    end

  end

end
