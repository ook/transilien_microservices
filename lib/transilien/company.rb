class Transilien::Company < Transilien::MicroService

  attr_accessor :name
  attr_accessor :external_code
  attr_accessor :access_time
  attr_accessor :payload
  attr_accessor :source_id

  class << self

    def action
      'CompanyList'
    end

    def find(filters={})
      response = super(filters)
      body = response.body
      companys = []
      doc = Nokogiri.XML(body)
      return errors(doc) unless errors(doc).empty?
      doc.xpath('/ActionCompanyList/CompanyList/Company').each do |node|
        company = new
        company.external_code = node['CompanyExternalCode']
        company.source_id = node['CompanyId']
        company.name = node['CompanyName']
        company.payload = node
        company.access_time = Time.parse(response.headers[:date])
        companys << company
      end
      companys
    end

  end

  def to_s
    "#<Transilien::Company external_code=#{@external_code.inspect} name=#{@name.inspect} >"
  end

end
