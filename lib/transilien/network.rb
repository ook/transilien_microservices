class Transilien::Network < Transilien::MicroService
  def lines
    @lines ||= Transilien::Line.find(network_external_code: external_code)
  end
end
