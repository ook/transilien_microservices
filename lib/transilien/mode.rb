class Transilien::Mode < Transilien::MicroService
  def mode_type
    @mode_type ||= Transilien::ModeType.find(mode_type_external_code: payload['ModeTypeExternalCode']).try(:first)
  end
end
