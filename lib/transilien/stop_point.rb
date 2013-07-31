class Transilien::StopPoint < Transilien::MicroService
end

class Transilien::Stop < Transilien::FakeMicroService
  attr_accessor :stop_at_second
  class << self
    def from_node(node, access_time)
      item = new
      item.stop_at_seconnode.at('StopTime')['TotalSeconds']
      item
    end
  end
end
