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

  def modes
    @modes ||= begin
      modes = []
      payload.at('ModeList').children.each do |mode|
        modes << Transilien::ModeType.from_node(mode, access_time)
      end
      modes
    end
  end
  alias_method :mode_types, :modes # ModeList ≠ ModeTypeList : bad naming from SNCF

  def city
    @city ||= Transilien::City.from_node(payload.at('City'), access_time)
  end

  def hangs
    @hangs ||= payload.at('HangList').children
  end

  def stop_points
    @stop_points ||= Transilien::StopPoint.find(stop_area_external_code: external_code)
  end

  def lines
    @lines ||= Transilien::Line.find(stop_area_external_code: external_code)
  end

  def codes
    @codes ||= lines.map(&:code).uniq.sort
  end

end
