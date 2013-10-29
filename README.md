# TransilienMicroservices

Ruby implementation of SNCF Transilien Microservices.

Here the original service documentation: http://test.data-sncf.com/index.php/transilien.html/api.22.22-micro-services.html

These services let you know the theoric offer on Transilien service.

Disclamer: The gem only intend to implements the API. I'll create a "easy" wrapper to access these data in a convenient way very soon.

## Installation

Gem developped with ruby 2.0.0, should work with ruby 1.9.3

Add this line to your application's Gemfile:

    gem 'transilien_microservices'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install transilien_microservices

## Usage

The best way to access data is certainly querying through StopArea: start by fetching them.

    stop_areas = Transilien::StopArea.find

Every Transilien "main" objects have the same attributes:

    stop_areas.first.inspect
    => "#<Transilien::StopArea external_code=\"DUA8738221\" name=\"LA DEFENSE GRANDE ARCHE\" >"

* "name" is a "public" name. Can't be filtered directly through Transilien API
* "external_code" is the true "key" to use in queries.

They have in bonus #payload method which return the node used to build this object.

If you want to find a commercial line that stops by two StopArea, say: Val d'Argenteuil (DUA8738179) and Paris Saint Lazare (DUA8738400) you can query this way:

    val_stlaz_lines = Transilien::Line.find(stop_area_external_code: {and: ['DUA8738400', 'DUA8738179']})

Ok, but to tell the truth, I doubt that you don't bother about the way: you're going from Val to StLaz, not the inverse, so precise it:

    val_to_stlaz_lines = Transilien::Line.find(destination_external_code: 'DUA8738400', stop_area_external_code: 'DUA8738179')

You get an Array of Transilien::Line fullfilling your wish.

Staying on that example, we'll stay with the "biggest" Line of the set: "Mantes la Jolie => Gare St Lazare via CONFLANS" DUA800854044
To get ALL the stops served by this Line:

    Transilien::StopArea.find(line_external_code: 'DUA800854044')

Ok, that's fun. But Transilien is all about train and departures. What are the trains going from Val d’Argenteuil to Paris Saint Lazare? Transilien::VehicleJourney is all about it

    instant = Time.new
    start_time = Time.local(instant.year, instant.month, instant.day, 17, 30)
    end_time = Time.local(instant.year, instant.month, instant.day, 18, 45)
    Transilien::VehicleJourney.find stop_area_external_code: {and: ['DUA8738400', 'DUA8738179'], date: Transilien.date(instant), start_time: Transilien.time(start_time), end_time: Transilien.time(end_time) }

Yeah! Better. You still have a problem: this give you all the journey starting between start_time and end_time on date instant, but don't give a fuck to your way.

Ready to forget what you just learnt? Go back a little bit before this point: a Line instance always have at least two Route (one way, the other). And its finder understand a convenient param: CheckOrder. If set to 1, and 2 stops are given, Route returned will honor the given way by stops order:

    routes_stlaz_val = Transilien::Route.find(stop_area_external_code: {and:['DUA8738400','DUA8738179']}, check_order: 1)

Here you have only Route stoping by DUA8738400 then DUA8738179, not the inverse.

Now it'll be easy to get VehicleJourney matching your needs. The same VehicleJourney will become:

    Transilien::VehicleJourney.find route_external_code: routes_stlaz_val.map(&:external_code), date: Transilien.date(instant), start_time: Transilien.time(start_time), end_time: Transilien.time(end_time)

Easier, isn't it? Now take every Stop and keep only your matching StopArea: you'll get your hours of departures and arrivals :)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

NOTA: you're a beginner gem dev? This command may help you: 

    pry -Ilib -rtransilien_microservices 

(you can replace pry with irb if you're not a good person…)
