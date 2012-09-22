#### Requirements

* Ruby 1.9.3
* Bundler

#### Run the server (Ruby)

    bundle --without client development test
    bundle exec bin/server

#### Run some clients (OpenGL)

    bundle --without server development test
    bundle exec bin/client
