class Transilien::VehicleJourney < Transilien::MicroService

  attr_accessor :name
  attr_accessor :external_code
  attr_accessor :access_time
  attr_accessor :payload

  class << self

    def action
      'VehicleJourneyList'
    end

    def find(filters={})
      response = super(filters)
      body = response.body
      vehicle_journeys = []
      doc = Nokogiri.XML(body)
      return errors(doc) unless errors(doc).empty?
      doc.xpath('/ActionVehicleJourneyList/VehicleJourneyList/VehicleJourney').each do |node|
        vehicle_journey = new
        vehicle_journey.external_code = node['VehicleJourneyExternalCode']
        vehicle_journey.name = node['VehicleJourneyName']
        vehicle_journey.payload = node
        vehicle_journey.access_time = Time.parse(response.headers[:date])
        vehicle_journeys << vehicle_journey
      end
      vehicle_journeys
    end

  end

  def to_s
    "#<Transilien::vehicleJourney external_code=#{@external_code.inspect} name=#{@name.inspect} >"
  end

end
