# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config
config :kafka_ex,
  brokers: [
    {"localhost",9092}
  ],
  consumer_group: "kafka_ex",
  disable_default_worker: false,
  sync_timeout: 3000,
  use_ssl: false

# General application configuration
config :gttex_analytics,
  ecto_repos: [GttexAnalytics.Repo]

# Configures the endpoint
config :gttex_analytics, GttexAnalyticsWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "BaFhkB61KUkQ06ec9ejKpQEIvjtcfgoNVzWnraGTPSVhJNEDZIeAYBiPTt6HNJEr",
  render_errors: [view: GttexAnalyticsWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: GttexAnalytics.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
env_config = Path.expand("#{Mix.env}.exs", __DIR__)
if File.exists?(env_config) do
  import_config(env_config)
end
