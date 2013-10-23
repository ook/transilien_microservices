# TransilienMicroservices

TODO: Write a gem description

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

TODO prochain exemple à donner c'est: 1 récupérer une route avec 2 stoparea + checkOrder activé (quel les routes dans le sens concerné) + VehiculeJourney + datetime boudnaries pour avoir très clairement ce qui nous intéresse, et voilà le taff est fait!



## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

NOTA: you're a beginner gem dev? This command may help you: pry -Ilib -rtransilien_microservices (you can replace pry with irb if you're not a good person…)
