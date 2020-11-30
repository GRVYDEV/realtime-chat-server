# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :chat_server,
  ecto_repos: [ChatServer.Repo]

# Configures the endpoint
config :chat_server, ChatServerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "oGNuO9e/vuyXe2vuL+HM3E0uPFyFRoWOk3LycYm2JZfaY09PFVjoe/CPxDYCR1HZ",
  render_errors: [view: ChatServerWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: ChatServer.PubSub,
  live_view: [signing_salt: "c+XtMa9N"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :chat_server, ChatServer.Guardian,
  issuer: "chatserver",
  secret_key: "Jbfh8/uKEylHja6tMelE2v4xDl5FPot0eecCtGcbsOF80C6h7lMJdY/PV2m+rc7k"
# Use Jason for JSON parsing in Phoenix


# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
