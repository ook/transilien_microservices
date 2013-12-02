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
end
