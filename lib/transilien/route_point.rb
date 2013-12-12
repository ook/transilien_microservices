class Transilien::RoutePoint < Transilien::MicroService
  def stop_point
    @stop_point ||= Transilien::StopPoint.find(stop_point_external_code: payload.at('StopPoint').at('StopPointExternalCode'))
  end
end
