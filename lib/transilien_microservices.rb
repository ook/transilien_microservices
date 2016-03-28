require "transilien/version.rb"
require "transilien/micro_service.rb"
require "transilien/time.rb"
require "transilien/network.rb"
require "transilien/mode_type.rb"
require "transilien/line.rb"
require "transilien/route.rb"
require "transilien/stop_point.rb"
require "transilien/stop_area.rb"
require "transilien/vehicle_journey.rb"
require "transilien/mode.rb"
require "transilien/company.rb"
require "transilien/stop.rb"

module Transilien
  def self.date(time)
    time.strftime('%Y|%m|%d')
  end
  def self.time(time)
    time.strftime('%H|%M')
  end
end
