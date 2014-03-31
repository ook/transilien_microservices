# Represents Time in Transilien MS API
# Theorically, you NEVER had to instanciate them by yourself
# Note: +total_seconds+ and +day+ looks like mysteries for myself right now…
class Transilien::Time < Transilien::FakeMicroService
  attr_accessor :total_seconds, :day, :hour, :minute

  class << self
    # Build a `Transilien::Time` from a Nokogiri::Node
    def from_node(node, access_time)
      item = new
      item.payload = node

      item.total_seconds = node.at('TotalSeconds').text
      item.day = node.at('Day').text.to_i
      item.hour = node.at('Hour').text.to_i
      item.minute = node.at('Minute').text.to_i
      item
    end
  end

  # String conversion of the instance.
  # It aims only to permit caching (see Transilien::Microservice class)
  # @return [String] representation of that instance
  def name
    "#{day}:#{hour}:#{minute}|#{total_seconds}"
  end

  # Convert this object to ruby `::Time`
  # Since the current time is not known, set it to `Time.new` year, month and day
  def time
    now = Time.new
    this_month_days_count = Date.new(now.year, now.month, -1).day
    return  Time.local(now.year + 1, 1, 1, hour, minute) if day == 1 && now.month == 12 && now.day == this_month_days_count
    return  Time.local(now.year, now.month + 1, 1, hour, minute) if day == 1 && this_month_days_count == now.day
    Time.local(now.year, now.month, now.day + day, hour, minute)
  end
end
