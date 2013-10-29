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

    Default_cache_duration = 300 # in second

    attr_accessor :caches
    attr_accessor :query_cache

    def http(uri = API_URI)
      @http ||= Faraday.new(:url => uri) do |faraday|
        # TODO give option to setup faraday
        faraday.request  :url_encoded             # form-encode POST params
        #faraday.response :logger                  # log requests to STDOUT 
        faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
      end
    end

    def find_from_full_query_cache(filters)
      @query_cache ||= {}
      if filters[:force_refresh]
        @query_cache.delete(filters.to_s)
      end
      if @query_cache[filters.to_s] && (@query_cache[filters.to_s][:cached_at].to_i + Default_cache_duration > Time.now.to_i)
        return @query_cache[filters.to_s][:payload]
      end
    end

    # Iterative search on per instance search. That's HARD.
    # WIP idea: since filters are prefixed by operator (AND by default), we can deal key by key. Collection on the first run is the matching
    # instances on that uniq key. The result will be the last collection returned. Potentially nil.
    def find_from_query_caches(filters, collection = nil, operator = nil)
      if collection.nil?
        # FIRST RUN
        filters.keys.each do |key|
          collection = [query_cache({key: key, value: filters[key]})]
        end
      end

    end

    # /?action=LineList&StopAreaExternalCode=DUA8754309;DUA8754513|and&RouteExternalCode=DUA8008030781013;DUA8008031050001|or
    # -> find(:stop_area_external_code => { :and => ['DUA8754309', 'DUA8754513'] }, :route_external_code => { :or => ['DUA8008030781013', 'DUA8008031050001'] })
    def find(filters = {}, options = {})
      collection =   find_from_full_query_cache(filters)
      collection ||= find_from_query_caches(filters)

      self.filters = filters
      response = self.http.get(action_param, params)
      puts('== Request: ')
      puts(action_param.inspect)
      puts(params.inspect)
      puts(response.env[:url].inspect)
      body = response.body
      collection = []
      doc = Nokogiri.XML(body)
      return errors(doc) unless errors(doc).empty?
      request_time = Time.parse(response.headers[:date])
      doc.xpath(action_instance_xpath).each do |node|
        item = from_node(node, request_time)
        collection << item
      end
      @query_cache[filters.to_s] = { payload: collection, cached_at: request_time }
      collection
    end

    def from_node(node, access_time)
      item = new
      item.payload = node

      # common stuff
      item.external_code = node["#{action_component}ExternalCode"]
      item.name = node["#{action_component}Name"]
      item.access_time = access_time

      cache_it(item)

      item
    end

    def cache_keys
      [:name, :external_code]
    end

    def cache_it(item)
      @caches ||= {}
      cache_keys.each do |k|
        @caches[k] ||= {}
        @caches[k][item.send(k)] = item
      end
      item
    end

    def query_cache(query = nil)
      return @caches unless query
      q = query || {}
      q[:key] ||= 'name'
      return nil if @caches.nil? || @caches[action_component].nil?
      (@caches[action_component][q[:key]] || []).each do |item|
        return item if item.name == q[:value]
      end
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
            raise ArgumentError.new("Operator #{operator} unknown. Should be one of #{ok_operators.inspect}.") unless ok_operators.include?(operator.to_sym)
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

class Transilien::FakeMicroService < Transilien::MicroService

  class << self
    def http(dummy=nil)
      raise "FakeMicroService: you can't request a connection a connection. Use #from_node instead"
    end
  end
end
