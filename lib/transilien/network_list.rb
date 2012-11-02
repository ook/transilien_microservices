class Transilien::NetworkList < Transilien::MicroService

  attr_accessor :name
  attr_accessor :external_code

  class << self

    def action
      'NetworkList'
    end

    def find(filters={})
      body = super(filters)
      networks = []
      doc = Nokogiri.XML(body)
      doc.xpath('/ActionNetworkList/NetworkList/Network').each do |node|
        puts node.inspect
        network = new
        network.external_code = node['NetworkExternalCode']
        network.name = node['NetworkName']
        networks << network
      end
      networks
    end

  end

  def to_s
    "#<NetworkList external_code=#{@external_code.inspect} name=#{@name.inspect} >"
  end

end
