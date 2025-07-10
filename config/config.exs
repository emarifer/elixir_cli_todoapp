import Config

config :todo,
  ecto_repos: [Todo.Repo],
  generators: [timestamp_type: :utc_datetime]

# Configuration for the library `Tzdata`
# config :elixir, :time_zone_database, Tzdata.TimeZoneDatabase

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
