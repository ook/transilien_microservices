class Transilien::Network < Transilien::MicroService

  attr_accessor :name
  attr_accessor :external_code
  attr_accessor :access_time
  attr_accessor :payload

  class << self

    def action
      'NetworkList'
    end

    def find(filters={})
      response = super(filters)
      body = response.body
      networks = []
      doc = Nokogiri.XML(body)
      return errors(doc) unless errors(doc).empty?
      doc.xpath('/ActionNetworkList/NetworkList/Network').each do |node|
        network = new
        network.external_code = node['NetworkExternalCode']
        network.name = node['NetworkName']
        network.payload = node
        network.access_time = Time.parse(response.headers[:date])
        networks << network
      end
      networks
    end

  end

  def to_s
    "#<Transilien::Network external_code=#{@external_code.inspect} name=#{@name.inspect} >"
  end

end
