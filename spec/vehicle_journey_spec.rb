require 'spec_helper'

describe Transilien::MicroService do
  it 'should get a set of Stop' do
    # This payload was generated from
    # http://ms.api.transilien.com/?action=VehicleJourneyList&RouteExternalCode=DUA8008540420003%3BDUA8008540430008%3BDUA8008540430010%3BDUA8008540430005%3BDUA8008544000030%3BDUA8008540440001|or&Date=2013|10|24&StartTime=18|19&EndTime=18|21
    vj = Transilien::VehicleJourney.from_node(Nokogiri.XML((Pathname.new('spec') + 'vehicle_journey_alone.xml').read), Time.now)
    vj.stops.first.class.should eql(Transilien::Stop)
  end
end
