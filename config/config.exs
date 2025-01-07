# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :pep,
  ecto_repos: [Pep.Repo],
  generators: [binary_id: true]

config :pep, Pep.Repo,
  migration_primary_key: [type: :binary_id],
  migration_foreign_key: [type: :binary_id]

# Configures the endpoint
config :pep, PepWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: PepWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Pep.PubSub,
  live_view: [signing_salt: "aT9rU2jA"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :pep, Pep.Mailer, adapter: Swoosh.Adapters.Local

# Swoosh API client is needed for adapters other than SMTP.
config :swoosh, :api_client, false

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# TZData config
config :tzdata, :autoupdate, :disabled

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"

# config timezone 
config :elixir, :time_zone_database, Tzdata.TimeZoneDatabase
config :tzdata, :data_dir, "/tmp/elixir_tzdata_data"
