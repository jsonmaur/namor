import Config

# Enable dev routes for dashboard and mailbox
config :namor_demo, dev_routes: true

# For development, we disable any cache and enable
# debugging and code reloading. The watchers configuration
# can be used to run external watchers to your application.
config :namor_demo, NamorDemoWeb.Endpoint,
  http: [ip: {0, 0, 0, 0}, port: 4000],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "ZS05nY0jJwUW+fCjDPjYhnP0A9QEia9+hIIbt8L9vjIV62BrJluM6KX3PXKnJo07",
  watchers: [
    esbuild: {Esbuild, :install_and_run, [:default, ~w(--watch)]},
    tailwind: {Tailwind, :install_and_run, [:default, ~w(--watch)]}
  ]

# Watch static and templates for browser reloading.
config :namor_demo, NamorDemoWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r"priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"lib/namor_demo_web/(html|layouts|live)/.*(ex|heex)$"
    ]
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime
