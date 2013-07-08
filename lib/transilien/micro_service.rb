require 'uri'
require 'faraday'
require 'nokogiri'
require 'time' # Time.parse for access_time in specialized instances

class Transilien::MicroService
  API_HOST = 'ms.api.transilien.com'
  API_URI = URI.parse("http://#{API_HOST}/")

  attr_accessor :name
  attr_accessor :external_code
  attr_accessor :access_time
  attr_accessor :payload

  class << self

    def http(uri = API_URI)
      @http ||= Faraday.new(:url => uri) do |faraday|
        # TODO give option to setup faraday
        faraday.request  :url_encoded             # form-encode POST params
        #faraday.response :logger                  # log requests to STDOUT 
        faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
      end
    end

    # /?action=LineList&StopAreaExternalCode=DUA8754309;DUA8754513|and&RouteExternalCode=DUA8008030781013;DUA8008031050001|or
    # -> find(:stop_area_external_code => { :and => ['DUA8754309', 'DUA8754513'] }, :route_external_code => { :or => ['DUA8008030781013', 'DUA8008031050001'] })
    def find(filters = {})
      self.filters = filters
      response = self.http.get(action_param, params)
      body = response.body
      collection = []
      doc = Nokogiri.XML(body)
      return errors(doc) unless errors(doc).empty?
      doc.xpath(action_instance_xpath).each do |node|
        item = new
        item.payload = node

        # common stuff
        item.external_code = node["#{action_component}ExternalCode"]
        item.name = node["#{action_component}Name"]
        item.access_time = Time.parse(response.headers[:date])

        collection << item
      end
      collection
    end

    def errors(doc)
      @errors ||= begin 
        @errors = []
        doc.xpath('/Errors/Error').each do |err_node|
          err = Transilien::MicroService::Error.new
          err.code = err_node['code']
          err.message = err_node.content
          err.request = { params: params, action: action_param}
          @errors << err
        end
        @errors
      end
    end


    def action_component
      self.to_s.split('::').last 
    end

    def action
      "#{action_component}List"
    end

    def action_param
      "/?action=#{action}"
    end

    def action_instance_xpath
      "/Action#{action}/#{action}/#{action_component}"
    end

    def params
      return {} if filters.empty?
      final = {}
      @filters.each do |filter, filter_value| 
        final_filter = filter.to_s.split('_').map(&:capitalize).join
        if filter_value.is_a?(Hash)
          filter_value.each_pair do |operator, values|
            ok_operators = [:and, :or]
            raise ArgumentError("Operator #{operator} unknown. Should be one of #{ok_operators.map(&to_s).join(', ')}.") unless ok_operators.include?(operator.to_sym)
            final_values = [values].flatten.compact.join(';')
            final[final_filter] = "#{final_values}|#{operator.to_s}"
          end
        elsif filter_value.is_a?(Array)
          # By default, consider OR operator when values are only an array
          final[final_filter] = "#{filter_value.join(';')}|or"
        else
          final[final_filter] = filter_value
        end
      end
      final
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
    "#<#{self.class.to_s} external_code=#{@external_code.inspect} name=#{@name.inspect} >"
  end

  class Error
    attr_accessor :code, :message, :payload, :request
  end

end
