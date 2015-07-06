# Heartcheck::Cache

[![Build Status](https://travis-ci.org/locaweb/heartcheck-cache.svg?branch=master)](https://travis-ci.org/locaweb/heartcheck-cache)

A plugin to check cache connection with heartcheck

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'heartcheck-cache'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install heartcheck-cache

## Usage

You can add a check to cache when configure the heartcheck

```ruby
Heartcheck.setup do |config|
  config.add :cache do |c|
    c.add_service(name: 'MyCacheConnection', connection: Dalli::Client.new('localhost:11211'))
  end
end
```

The service is a Hash that needs to respond to `:name` to identify the service and `:connection` that is recommended to use the cache connection that your app is using.
Ex.

```ruby
Heartcheck.setup do |config|
  config.add :cache do |c|
    c.add_service(name: 'MyCacheConnection', connection: Rails.cache.instance_variable_get("@data"))
  end
end
```

## Contributing

1. Fork it ( https://github.com/locaweb/heartcheck-cache )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
