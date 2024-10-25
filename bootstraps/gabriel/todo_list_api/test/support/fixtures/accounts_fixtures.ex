defmodule TodoListApi.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TodoListApi.Accounts` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        firstname: "some firstname",
        lastname: "some lastname"
      })
      |> TodoListApi.Accounts.create_user()

    user
  end
end
