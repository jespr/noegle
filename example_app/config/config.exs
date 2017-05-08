# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :example_app,
  namespace: NoegleExampleApp,
  ecto_repos: [NoegleExampleApp.Repo]

# Configures the endpoint
config :example_app, NoegleExampleApp.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "B8RUFTIXznXRnv//ygjwOrRd02ona6voYp/9GDHgzB3ndlndsC1cfFGU1H0kLBso",
  render_errors: [view: NoegleExampleApp.ErrorView, accepts: ~w(html json)],
  pubsub: [name: NoegleExampleApp.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :noegle,
  repo: NoegleExampleApp.Repo,
  user: NoegleExampleApp.User

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
