import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :time_manager, TimeManager.Repo,
  username: System.get_env("PGUSER"),
  password: System.get_env("PGPASSWORD"),
  hostname: System.get_env("PGHOST"),
  database: "#{System.get_env("PGDATABASE")}#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: System.schedulers_online() * 2

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :time_manager, TimeManagerWeb.Endpoint,
  http: [ip: {0, 0, 0, 0}, port: 4002],
  secret_key_base: "MsCoCB29g81SpfHM0pTIGO+VjOs6TnRP1bQc0DcoHa9kqay9E0QGaNhGB2TzP3iO",
  server: false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

config :time_manager, TimeManager.Guardian,
       issuer: "time_manager",
       secret_key: "ycjowwWHTTEZ4LYNiW8GcGEHrzqRtj0WnZoVffkCRO9vK1L6vKTc8nUWQbzSbZ6K"