defmodule TimeManager.UsersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TimeManager.Users` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: "fixture@test.test",
        username: "fixture_username",
        password: "fixture_password"
      })
      |> TimeManager.Users.create_user()

    %{user | password: nil}
  end

  def user_fixture_test(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: "test@test.test",
        username: "test_username",
        password: "test_password"
      })
      |> TimeManager.Users.create_user()

    user
  end

end
