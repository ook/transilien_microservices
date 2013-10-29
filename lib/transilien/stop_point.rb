class Transilien::StopPoint < Transilien::MicroService
  def fare_zone
    @fare_zone ||= payload['FareZone']
  end

  def address
    payload.at('StopPointAddress')
  end
  alias_method :stop_point_address, :address

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
    #@stop_area ||= Transilien::StopArea.from_node(payload.at('StopArea'), access_time)
    @stop_area ||= Transilien::StopArea.find(stop_area_external_code: payload.at('StopArea')['StopAreaExternalCode']).first
  end

  def coord
    @coord ||= {
      x: payload.at('Coord').at('CoordX').content.sub(',','.').to_f,
      y: payload.at('Coord').at('CoordY').content.sub(',','.').to_f
    }
  end
end
