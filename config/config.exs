# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :lov,
  ecto_repos: [Lov.Repo]

# Configures the endpoint
config :lov, LovWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "PrDtXiz379f5DX2KmadzVKfOHQj2/ypP/Y2mnjEZOBbWd79YCw82x6mbZ0619Q41",
  render_errors: [view: LovWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Lov.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "FWjq0Sj6"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
