# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

# Configures the endpoint
config :namor_demo, NamorDemoWeb.Endpoint,
  url: [host: "localhost"],
  pubsub_server: NamorDemo.PubSub,
  live_view: [signing_salt: "lHGGHnrT"],
  render_errors: [
    layout: false,
    formats: [html: NamorDemoWeb.ErrorHTML]
  ]

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.15.18",
  default: [
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)},
    args: ~w(
      --bundle
      --target=es2017
      --outdir=../priv/static/assets
      js/app.js
    )
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.2.4",
  default: [
    cd: Path.expand("../assets", __DIR__),
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    )
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
