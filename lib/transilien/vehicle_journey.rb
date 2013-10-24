class Transilien::VehicleJourney < Transilien::MicroService
  def route
    @route ||= Transilien::Route.from_node(payload.at('Route'), access_time)
  end
  def mode
    @mode ||= Transilien::Mode.from_node(payload.at('Mode'), access_time)
  end
  def company
    @company ||= Transilien::Company.from_node(payload.at('Company'), access_time)
  end
  def vehicle
    @vehicle ||= payload.at('Vehicle')
  end
  def validity_pattern
    @validity_pattern ||= payload.at('ValidityPattern')
  end

  def stops
    @stops ||= begin
      stops_node = payload.at('StopList')
    end
  end
end
