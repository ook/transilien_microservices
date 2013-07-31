class Transilien::StopPoint < Transilien::MicroService
  def fare_zone
    @fare_zone ||= payload['FareZone']
  end

  def address
    payload.at('StopPointAddress')
  end

  def equipment
    @equipment ||= {
        sheltered:     (payload.at('Equipment')['Sheltered']    == 'True'),
        mimp_access:   (payload.at('Equipment')['MIPAccess']    == 'True'),
        elevator:      (payload.at('Equipment')['Elevator']     == 'True'),
        escalator:     (payload.at('Equipment')['Escalator']    == 'True'),
        bike_accepted: (payload.at('Equipment')['BikeAccepted'] == 'True'),
        bike_depot:    (payload.at('Equipment')['BikeDepot']    == 'True')
      }
  end

  def mode
    @mode ||= Transilien::Mode.from_node(payload.at('Mode'), access_time)
  end

  def city
    @city ||= Transilien::City.from_node(payload.at('City'), access_time)
  end

  def stop_area
    @stop_area ||= Transilien::StopArea.from_node(payload.at('StopArea'), access_time)
  end

  def coord
    @coord ||= {
      x: payload.at('Coord').at('CoordX').content.sub(',','.').to_f,
      y: payload.at('Coord').at('CoordY').content.sub(',','.').to_f
    }
  end
end

class Transilien::Stop < Transilien::FakeMicroService
  attr_accessor :stop_at_second, :arrival_at_second
  class << self
    def from_node(node, access_time)
      node.children.each do |stop|
        item = new
        item.stop_at_second = stop.at('StopTime').try(:at, 'TotalSeconds').to_i
        item.arrival_at_second = stop.at('ArrivalTime').try(:at, 'TotalSeconds').to_i
        item.payload = stop
      end
    end
  end

  def stop_point
    @stop_point ||= Transilien::StopPoint.from_node(payload.at('StopPoint'), access_time)
  end
end
