class Transilien::Network < Transilien::MicroService
  def lines
    @lines ||= Transilien::Line.find(network_external_code: external_code)
  end

  def codes
    @codes ||= lines.line_code.uniq.sort
  end
end
