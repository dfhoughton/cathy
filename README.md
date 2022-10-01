# Cathy

`Cathy` facilitates modeling a weighted probability distribution from which one can draw a sample. Say you
want to pick a realistic weather forecast and you know there's one sunny day for every two cloudy days and one
rainy day for every two sunny days. `Cathy` will let you model this. But more importantly, `Cathy` will let you
modify the probabilities on the fly (if you don't need an updatable distribution, I suggest you try
[`pick_me_too`](https://github.com/dfhoughton/pick_me_too), which is more efficient in this case).

## Synopsis

```ruby
require 'cathy'

# make a new distribution
cathy = Cathy.new

# teach cathy some things
10.times { cathy.add :foo }
5.times { cathy.add :bar }
2.times { cathy.add :plugh }

# ask cathy for a sample
10.times.map { cathy.pick } # => [:foo, :foo, :bar, :foo, :foo, :foo, :foo, :foo, :plugh, :foo]

# teach cathy more things!
20.times { cathy.add :plugh }

# another sample
10.times.map { cathy.pick } # => [:plugh, :plugh, :foo, :bar, :foo, :bar, :plugh, :plugh, :foo, :plugh]
```

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add cathy

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install cathy

## Usage

### `Cathy#new`

Make 

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/cathy. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/cathy/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Cathy project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/cathy/blob/main/CODE_OF_CONDUCT.md).

## Efficiency

My aim in writing this has been to be lean on memory usage and to use as few mathematical operations and fetches from memory as possible
when picking things. The underlying data structure is a [heap](https://en.wikipedia.org/wiki/Heap_(data_structure)), which allows drawing
a sample in sub-logarithmic time in the typical case using only integer subtraction, and comparison. Updating is similarly efficient.

## Name

Cathy is named after [Chatty Cathy](https://en.wikipedia.org/wiki/Chatty_Cathy). Why? Because the only time I wanted to have
this was when I made a chat bot for my kids to play with.

Also, naming is hard.

## Acknowledgements

My wife Paula and son Jude have been exceedingly tolerant of my messing about with this silliness. Also, my co-workers at [Green River](https://www.greenriver.com/) have humored me.
