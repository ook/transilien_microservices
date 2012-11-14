class Transilien::Network < Transilien::MicroService

  attr_accessor :name
  attr_accessor :external_code
  attr_accessor :access_time

  class << self

    def action
      'NetworkList'
    end

    def find(filters={})
      body = super(filters)
      networks = []
      doc = Nokogiri.XML(body)
      doc.xpath('/ActionNetworkList/NetworkList/Network').each do |node|
        network = new
        network.external_code = node['NetworkExternalCode']
        network.name = node['NetworkName']
        networks << network
      end
      networks
    end

  end

  def to_s
    "#<Network external_code=#{@external_code.inspect} name=#{@name.inspect} >"
  end

end
