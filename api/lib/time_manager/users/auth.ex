defmodule TimeManager.Users.Auth do
  alias TimeManager.Repo
  alias TimeManager.Users.User

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def authenticate_user(email, password) do
    user = Repo.get_by(User, email: email)
    case check_password(user, password) do
      true -> {:ok, user}
      false -> {:error, :unauthorized}
    end
  end

  defp check_password(user, password) do
    case user do
      nil -> Bcrypt.no_user_verify()
      _ -> Bcrypt.verify_pass(password, user.password_hash)
    end
  end
end