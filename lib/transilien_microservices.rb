require "./lib/transilien/version.rb"
require "./lib/transilien/micro_service.rb"
require "./lib/transilien/time.rb"
require "./lib/transilien/network.rb"
require "./lib/transilien/mode_type.rb"
require "./lib/transilien/line.rb"
require "./lib/transilien/route.rb"
require "./lib/transilien/stop_point.rb"
require "./lib/transilien/stop_area.rb"
require "./lib/transilien/vehicle_journey.rb"
require "./lib/transilien/mode.rb"
require "./lib/transilien/company.rb"
require "./lib/transilien/stop.rb"

module Transilien
  def self.date(time)
    time.strftime('%Y|%m|%d')
  end
  def self.time(time)
    time.strftime('%H|%M')
  end
end
