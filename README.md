# TransilienMicroservices

Ruby implementation of SNCF Transilien Microservices.

Here is the original service documentation: http://test.data-sncf.com/index.php/transilien.html/api.22.22-micro-services.html

These services let you know the theoric train times on the Transilien service.

Disclamer: The gem only intends to implements the API. If you want a « logical » way to exploits SNCF data, see EasyTransilien gem: https://github.com/ook/easy_transilien

## Installation

Gem developped with ruby 2.0.0, should work with ruby 1.9.3.

Add this line to your application's Gemfile:

```ruby
gem 'transilien_microservices'
````

And then execute:

```sh
$ bundle
```

Or install it yourself as:

```sh
$ gem install transilien_microservices
```

## Usage

The best way to access data is certainly querying through `StopArea`. Start by fetching them.

```ruby
stop_areas = Transilien::StopArea.find
```

Every Transilien "main" object has the same attributes:

```ruby
stop_areas.first.inspect
=> "#<Transilien::StopArea external_code=\"DUA8738221\" name=\"LA DEFENSE GRANDE ARCHE\" >"
```

* `name` is a "public" name. Can't be filtered directly through Transilien API
* `external_code` is the true "key" to use in queries.

As a bonus method, `#payload` returns the node used to build this object.

If you want to find a commercial line that stops by two `StopArea`, say: Val d'Argenteuil (DUA8738179) and Paris Saint Lazare (DUA8738400) you can query them this way:

```ruby
val_stlaz_lines = Transilien::Line.find(stop_area_external_code: {and: ['DUA8738400', 'DUA8738179']})
```

Ok, but you will probably care about the direction you're taking. You're going from Val to StLaz, not the inverse, so precise it:

```ruby
val_to_stlaz_lines = Transilien::Line.find(destination_external_code: 'DUA8738400', stop_area_external_code: 'DUA8738179')
```

You get an `Array` of `Transilien::Line` that meet your wish.

Staying on this example, we'll stay with the "biggest" Line of the set: "Mantes la Jolie => Gare St Lazare via CONFLANS" DUA800854044
To get ALL the stops served by this Line:

```ruby
Transilien::StopArea.find(line_external_code: 'DUA800854044')
```

Ok, that's fun. But Transilien is all about train and departures. What are the trains going from Val d’Argenteuil to Paris Saint Lazare? `Transilien::VehicleJourney` is all about it:

```ruby
instant = Time.new
start_time = Time.local(instant.year, instant.month, instant.day, 17, 30)
end_time = Time.local(instant.year, instant.month, instant.day, 18, 45)
Transilien::VehicleJourney.find stop_area_external_code: {and: ['DUA8738400', 'DUA8738179'], date: Transilien.date(instant), start_time: Transilien.time(start_time), end_time: Transilien.time(end_time) }
```

Yeah! Better. You still have a problem: this gives you all the journeys starting between `start_time` and `end_time`, but doesnt't give a fuck about your direction.

Ready to forget what you just learnt? Go back a little bit before this point: a `Line` instance always has at least two `Route` (one way and the other). And its finder accepts a convenient parameter: `check_order`. If set to `1` or `2` stops, `Route` returned will honor the given way by stops order:

```ruby
routes_stlaz_val = Transilien::Route.find(stop_area_external_code: {and:['DUA8738400','DUA8738179']}, check_order: 1)
```

Here you only get `Route`s stoping by DUA8738400 then DUA8738179, not the inverse.

Now it'll be easy to get a `VehicleJourney` matching your needs. The same `VehicleJourney` will become:

```
Transilien::VehicleJourney.find route_external_code: routes_stlaz_val.map(&:external_code), date: Transilien.date(instant), start_time: Transilien.time(start_time), end_time: Transilien.time(end_time)
```

Easier, isn't it? Now take every `Stop` and keep only your matching `StopArea`: you'll get your hours of departures and arrivals :)

## Documentation

You're reading it… Ok, have a look to http://rubydoc.info/gems/transilien_microservices for code documentation. Note: you'll get a better understanding of that implementations if your read API documentation, see first link.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

NOTA: you're a beginner gem dev? This command may help you: 

```sh
$ pry -Ilib -rtransilien_microservices 
```

(You can replace `pry` with `irb` if you're not that kind of person…)
