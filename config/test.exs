import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :weather, Weather.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "weather_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :weather, WeatherWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "d0NWldFp1fEkk1HFUOAkEVYC+2gozTbkxnCpDsD+L9bvSUa1iC3Q5H99ZfetKe0t",
  server: false

# In test we don't send emails.
config :weather, Weather.Mailer, adapter: Swoosh.Adapters.Test

# Use mock API client for test environment.
config :weather, :weather_api_client, Weather.ApiClients.OpenWeatherMock

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
