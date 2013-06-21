class Transilien::ModeType < Transilien::MicroService

  attr_accessor :name
  attr_accessor :external_code
  attr_accessor :access_time
  attr_accessor :payload
  attr_accessor :source_id

  class << self

    def action
      'ModeTypeList'
    end

    def find(filters={})
      response = super(filters)
      body = response.body
      modes = []
      doc = Nokogiri.XML(body)
      return errors(doc) unless errors(doc).empty?
      doc.xpath('/ActionModeTypeList/ModeTypeList/ModeType').each do |node|
        mode = new
        mode.external_code = node['ModeTypeExternalCode']
        mode.source_id = node['ModeTypeId']
        mode.name = node['ModeTypeName']
        mode.payload = node
        mode.access_time = Time.parse(response.headers[:date])
        modes << mode
      end
      modes
    end

  end

  def to_s
    "#<Transilien::ModeType external_code=#{@external_code.inspect} name=#{@name.inspect} >"
  end

end
