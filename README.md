# Weather [![CI](https://github.com/georgiybykov/weather/actions/workflows/ci.yml/badge.svg)](https://github.com/georgiybykov/weather/actions)

Application for fetching weather data by city name from https://openweathermap.org/ external API.

## Installation

You should have an account on https://openweathermap.org/. Create an `APP_UNIQUE_API_KEY` at https://home.openweathermap.org/api_keys page.

```fish
$ git clone git@github.com:georgiybykov/weather.git
$ cd weather

# Create `.env` file to store sensitive environment variables and add your `APP_UNIQUE_API_KEY` there:
$ touch .env | echo 'export OPEN_WEATHER_API_KEY=APP_UNIQUE_API_KEY' >> .env
$ source .env

# Install and compile dependencies:
$ mix do deps.get, deps.compile

# Create and migrate your database:
$ mix ecto.setup

# Start Phoenix endpoint with:
$ mix phx.server

# or inside IEx with:
$ iex -S mix phx.server
```

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.
