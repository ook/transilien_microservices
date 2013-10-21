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

You get an Array of Transilien::Line fullfilling your wish.

Staying on that example, we'll stay with the "biggest" Line of the set: "Mantes la Jolie => Gare St Lazare via CONFLANS" DUA800854044
To get ALL the stops served by this Line:

    Transilien::StopArea.find(line_external_code: 'DUA800854044')

Ok, that's fun. But Transilien is all about train and departures. What are the trains going from Val d’Argenteuil to Paris Saint Lazare? Transilien::VehicleJourney is all about it

    Transilien::VehicleJourney.find


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

NOTA: you're a beginner gem dev? This command may help you: pry -Ilib -rtransilien_microservices (you can replace pry with irb if you're not a good person…)
