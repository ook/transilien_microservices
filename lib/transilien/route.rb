class Transilien::Route < Transilien::MicroService

  attr_accessor :name
  attr_accessor :external_code
  attr_accessor :access_time
  attr_accessor :payload

  class << self

    def action
      'RouteList'
    end

    def find(filters={})
      response = super(filters)
      body = response.body
      routes = []

      doc = Nokogiri.XML(body)
      doc.xpath('/ActionRouteList/RouteList/Route').each do |node|
        route = new
        route.external_code = node['RouteExternalCode']
        route.name = node['RouteName']
        route.payload = node
        route.access_time = Time.parse(response.headers[:date])
        routes << route
      end
      routes
    end

  end

  def to_s
    "#<Transilien::Route external_code=#{@external_code.inspect} name=#{@name.inspect} >"
  end

end
