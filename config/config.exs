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
  secret_key_base: "7gYIDhzT/IrdD8WduhbioVvmq57tro2xUn9dyCh9eUS8YajpEdVfG6uXn/dZrqOJ",
  render_errors: [view: LovWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Lov.PubSub,
  live_view: [signing_salt: "70JpZQWw"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
