use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :nfl_rushing, NflRushingWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

config :nfl_rushing, :data_source_path, "test/support/files/rushing.json"
config :nfl_rushing, :download_path, "test/support/files/"
