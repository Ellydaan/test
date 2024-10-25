defmodule TimeManager.GuardianTestHelper do
  use Phoenix.ConnTest

  def setup_authenticated_conn(conn, user) do
    config = Application.get_env(:time_manager, TimeManager.Guardian)
    secret_key = Keyword.get(config, :secret_key)
    {:ok, token, _claims} = TimeManager.Guardian.encode_and_sign(user, %{}, secret: secret_key)
    conn
    |> put_req_header("authorization", "Bearer #{token}")
  end

  def setup_authenticated_socket(socket, user) do
    {:ok, token, _claims} = Guardian.encode_and_sign(user)
    Guardian.Phoenix.Socket.put_current_token(socket, token)
  end
end