class Transilien::Time < Transilien::FakeMicroService
  attr_accessor :total_seconds, :day, :hour, :minute

  class << self
    def from_node(node, access_time)
      item = new
      item.payload = node

      item.total_seconds = node.at('TotalSeconds').text
      item.day = node.at('Day').text
      item.hour = node.at('Hour').text
      item.minute = node.at('Minute').text
      item
    end
  end

  def name # objective: enable caching
    "#{day}:#{hour}:#{minutes}|#{total_seconds}"
  end
end
