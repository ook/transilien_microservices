class Transilien::StopArea < Transilien::MicroService
  def main_stop_area
    @main_stop_area ||= payload['MainStopArea'] == '1'
  end

  def multi_modal
    @multi_modal ||= payload['MultiModal'] == '1'
  end

  def car_park
    @car_park ||= payload['CarPark'] == '1'
  end

  def main_connection
    @main_connection ||= payload['MainConnection'] == '1'
  end

  def additional_data
    @additional_data ||= payload['AdditionalData']
  end

  def resa_rail_code
    @resa_rail_code ||= payload['ResaRailCode']
  end

  def coord
    @coord ||= {
      x: payload.at('Coord').at('CoordX').content.sub(',','.').to_f,
      y: payload.at('Coord').at('CoordY').content.sub(',','.').to_f
    }
  end
end
