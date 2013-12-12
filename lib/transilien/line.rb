class Transilien::Line < Transilien::MicroService
  def mode_type
    @mode_type ||= Transilien::ModeType.from_node(payload.at('ModeType'), access_time)
  end
  def network
    @network ||= Transilien::Network.from_node(payload.at('Network'), access_time)
  end

  # I don't have a clue what is about…
  def forward
    payload.at('Forward')
  end

  # I don't have a clue what is about…
  def backward
    payload.at('Backward')
  end

  def code
    payload['LineCode']
  end

  def stop_points
    @stop_points ||= Transilien::StopPoint.find(line_external_code: external_code)
  end

  def stop_areas
    @stop_areas ||= Transilien::StopArea.find(line_external_code: external_code)
  end

  def routes
    @routes ||= Transilien::Route.find(line_external_code: external_code)
  end
end
