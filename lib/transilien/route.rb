class Transilien::Route < Transilien::MicroService
  def line
    @line ||= Transilien::Line.from_node(payload.at('Line'), access_time)
  end
end

class Transilien::City < Transilien::FakeMicroService
  attr_accessor :code
  def from_node(node, access_time)
    item = super(node, access_time)
    item.code(node['CityCode'])
  end
end
