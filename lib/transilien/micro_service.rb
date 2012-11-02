require 'uri'
require 'faraday'
require 'nokogiri'

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

    # /?action=LineList&StopAreaExternalCode=DUA8754309;DUA8754513|and&RouteExternalCode=DUA8008030781013;DUA8008031050001|or
    # -> find(:stop_area_external_code => { :and => ['DUA8754309', 'DUA8754513'] }, :route_external_code => { :or => ['DUA8008030781013', 'DUA8008031050001'] })
    def find(filters = {})
      self.filters = filters
      self.http.get("/?action=#{action}#{params}").body
    end

    def action
      raise 'This is an abstract class. You must inherit it and override #action method.'
    end

    def params
      return '' if filters.empty?
      @filters.map do |filter, filter_value| 
        if filter_value.is_a?(Hash)
          operator, values = filter_value
          ok_operators = [:and, :or]
          raise ArgumentError("Operator #{operator} unknown. Should be one of #{ok_operators.map(&to_s).join(', ')}.") unless ok_operators.include(operator.to_sym)
          final_values = [values].flatten.compact.join(';')
          "#{final_values}|#{operator.to_s}"
        else
          "#{filter}=#{filter_value}"
        end
      end.join('&')
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

  def to_s
    super
  end


end
