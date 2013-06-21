class Transilien::Mode < Transilien::MicroService

  attr_accessor :name
  attr_accessor :external_code
  attr_accessor :access_time
  attr_accessor :payload
  attr_accessor :source_id

  class << self

    def action
      'ModeList'
    end

    def find(filters={})
      response = super(filters)
      body = response.body
      modes = []
      doc = Nokogiri.XML(body)
      return errors(doc) unless errors(doc).empty?
      doc.xpath('/ActionModeList/ModeList/Mode').each do |node|
        mode = new
        mode.external_code = node['ModeExternalCode']
        mode.source_id = node['ModeId']
        mode.name = node['ModeName']
        mode.payload = node
        mode.access_time = Time.parse(response.headers[:date])
        modes << mode
      end
      modes
    end

  end

  def to_s
    "#<Transilien::Mode external_code=#{@external_code.inspect} name=#{@name.inspect} >"
  end

end
