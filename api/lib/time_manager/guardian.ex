defmodule TimeManager.Guardian do
  use Guardian, otp_app: :time_manager

  alias TimeManager.Users

  def subject_for_token(user, _claims) do
    sub = to_string(user.id)
    {:ok, sub}
  end

  def resource_from_claims(claims) do
    user_id = claims["sub"]
    user = Users.get_user!(user_id)
    {:ok, user}
  end

  def build_claims(claims, user, _opts) do
    claims = claims
             |> Map.put("user_id", user.id)
             |> Map.put("user_role", user.role)
    {:ok, claims}
  end
end