class Transilien::Route < Transilien::MicroService
  def line
    @line ||= Transilien::Line.from_node(payload.at('Line'), access_time)
  end
end
