defmodule TimeManagerWeb.AuthPipeline do
  use Guardian.Plug.Pipeline,
      otp_app: :time_manager,
      module: TimeManager.Guardian,
      error_handler: TimeManagerWeb.AuthErrorHandler

  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource, allow_blank: true
end