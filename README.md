# InkscapeCLI
Simple ruby wrapper for inkscape cli

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add inkscape_cli

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install inkscape_cli

## Usage
```ruby
require 'inkscape_cli'

command = InkscapeCLI::Command.new
command.input_file = 'input.svg'
command.export_width(500)
command.export_filename('out.png')
command.execute

InkscapeCLI::Command.new.input_file('input.svg').export_filename('out.png').execute

InkscapeCLI::Command.new do |command|
  command.input_file = 'input.svg'
  command.export_filename = 'out.png'
end
```

## Configuration
```ruby
InkscapeCLI.configure do |config|
  config.executable = 'inkscape'
  config.timeout = 300
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/inkscape_cli.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
