class Transilien::StopPoint < Transilien::MicroService

  attr_accessor :name
  attr_accessor :external_code
  attr_accessor :access_time
  attr_accessor :payload

  class << self

    def action
      'StopPointList'
    end

    def find(filters={})
      response = super(filters)
      body = response.body
      stop_points = []

      doc = Nokogiri.XML(body)
      doc.xpath('/ActionStopPointList/StopPointList/StopPoint').each do |node|
        stop_point = new
        stop_point.external_code = node['StopPointExternalCode']
        stop_point.name = node['StopPointName']
        stop_point.payload = node
        stop_point.access_time = Time.parse(response.headers[:date])
        stop_points << stop_point
      end
      stop_points
    end

  end

  def to_s
    "#<Transilien::StopPoint external_code=#{@external_code.inspect} name=#{@name.inspect} >"
  end

end
