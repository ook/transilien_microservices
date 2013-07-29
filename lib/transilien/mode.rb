class Transilien::Mode < Transilien::MicroService

  attr_accessor :mode_type

  class << self

    def find(filters={})
      modes = super(filters)
      modes.each do |mode|
        mode.mode_type = mode.payload['ModeTypeExternalCode']
      end
      modes
    end

  end


end
