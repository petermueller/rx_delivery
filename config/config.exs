# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :rx_delivery,
  ecto_repos: [RxDelivery.Repo]

# Configures the endpoint
config :rx_delivery, RxDeliveryWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "6fL4/nOr1+ADDKeQVFwbnnkqSNat1Jf7ezcOGa4qWxapOVn0KbulvUYfp71g4pn/",
  render_errors: [view: RxDeliveryWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: RxDelivery.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
