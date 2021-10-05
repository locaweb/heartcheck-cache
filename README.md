# Heartcheck::Cache

[![Build Status](https://travis-ci.org/locaweb/heartcheck-cache.svg?branch=master)](https://travis-ci.org/locaweb/heartcheck-cache)
[![Code Climate](https://codeclimate.com/github/locaweb/heartcheck-cache/badges/gpa.svg)](https://codeclimate.com/github/locaweb/heartcheck-cache)

A plugin to check cache connection with [heartcheck](https://github.com/locaweb/heartcheck).

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

You can check any cache connection that there's in your app.
Each service need to respond to `:name` (an indetifier) and `:connection` (an activerecord connection)

```ruby
Heartcheck.setup do |config|
  config.add :cache do |c|
    c.add_service(name: 'MyCacheConnection', connection: Dalli::Client.new('localhost:11211'))
  end
end
```

If you need check the `Rails.cache` this service need be added with dynamic service;
The dynamic service is a Hash that needs to respond to `:name` to identify the service and `:connection` that is recommended to use the cache connection that your app is using.
Ex.

```ruby
Heartcheck.setup do |config|
  config.add :cache do |c|
    c.add_service(name: 'MyRailsCacheConnection', connection: Rails.cache.instance_variable_get("@data"))
  end
end
```

**Check Heartcheck example** [here](https://github.com/locaweb/heartcheck/blob/master/lib/heartcheck/generators/templates/config.rb)

## Development setup using Docker

The Docker Hearthcheck-Cache provides a container with the current stable version of Ruby released and a second Docker container running Memcached. The development setup requires you to have these tools available in your local environment:

-   [Docker](https://docs.docker.com/get-docker/)
-   [Docker Compose](https://docs.docker.com/compose/install/)
-   [Bash](https://www.gnu.org/software/bash/)

#### BootStrap Script to run the dockerized environment

```bash
./scripts/heartcheck-cache setup
```

Run the command `./scripts/heartcheck-cache -h` to see available options.

## Contributing

1.  Fork it ( https://github.com/locaweb/heartcheck-cache )
2.  Create your feature branch ( **git checkout -b my-new-feature** )
3.  Commit your changes ( **git commit -am 'Add some feature'** )
4.  Push to the branch ( **git push origin my-new-feature** )
5.  Create a new Pull Request

## License
*   [MIT License](https://github.com/locaweb/heartcheck-cache/blob/master/LICENSE.txt)
