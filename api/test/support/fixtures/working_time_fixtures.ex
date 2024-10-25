defmodule TimeManager.WorkingTimeFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TimeManager.WorkingTime` context.
  """
  import TimeManager.UsersFixtures
  @doc """
  Generate a working_times.
  """
  def working_times_fixture(attrs \\ %{}) do
    user = user_fixture()
    {:ok, working_times} =
      attrs
      |> Enum.into(%{
        end: ~N[2024-10-07 13:06:00],
        start: ~N[2024-10-07 13:06:00],
        user_id: user.id
      })
      |> TimeManager.WorkingTime.create_working_times()

    working_times
  end
end
