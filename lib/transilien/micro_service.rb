require 'uri'

class Transilien::MicroService
  API_HOST = 'ms.api.transilien.com'
  API_URI = URI.parse("http://#{API_HOST}/")

  class << self

    def http(uri = API_URI)
      @http ||= Faraday.new(:url => uri) do |faraday|
        # TODO give option to setup faraday
        faraday.request  :url_encoded             # form-encode POST params
        faraday.response :logger                  # log requests to STDOUT 
        faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
      end
    end

    def find
      self.http.get("/?action=#{action}#{params}")
    end

    def action
      raise 'This is an abstract class. You must inherit it and override #action method.'
    end

    def params
      return '' if filters.empty?
      @filters.map { |k,v| "#{k}=#{v}" }.join('&')
    end

    def filters
      @filters ||= {}
    end

    def filters=(new_filters)
      raise ArgumentError.new('filters= -> new_filters MUST be a hash, even empty') unless new_filters.is_a?(Hash)
      @filters = new_filters
    end

    def add_filters()
      self.filters
    end

  end


end
