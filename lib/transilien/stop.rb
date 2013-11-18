class Transilien::Stop < Transilien::FakeMicroService
  attr_accessor :stop_time, :arrival_time, :name_at_stop

  class << self
    def from_node(node, access_time)
      item = new
      item.access_time = access_time
      item.payload = node

      stop_node = node.at('StopTime')
      item.stop_time = !stop_node.children.empty? && ::Transilien::Time.from_node(stop_node, access_time)

      arrival_node = node.at('StopArrivalTime')
      item.arrival_time = !arrival_node.children.empty? && ::Transilien::Time.from_node(arrival_node, access_time)

      item.name_at_stop = node.at('VehicleJourneyNameAtStop') && node.at('VehicleJourneyNameAtStop').text
      item
    end
  end

  def stop_point
    @stop_point ||= Transilien::StopPoint.from_node(payload.at('StopPoint'), access_time)
  end

  def name # objective: enable caching
    "#{stop_time.name}||#{arrival_time.name}"
  end
end
