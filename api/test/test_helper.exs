ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(TimeManager.Repo, :manual)


Application.put_env(:time_manager, TimeManager.Guardian,
  issuer: "time_manager",
  secret_key: "ycjowwWHTTEZ4LYNiW8GcGEHrzqRtj0WnZoVffkCRO9vK1L6vKTc8nUWQbzSbZ6K"
)