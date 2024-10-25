defmodule TimeManager.TimeFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TimeManager.Time` context.
  """

  import TimeManager.UsersFixtures
  @doc """
  Generate a clock.
  """
  def clock_fixture(attrs \\ %{}) do
    user = user_fixture();

    {:ok, clock} =
      attrs
      |> Enum.into(%{
        status: true,
        time: ~N[2024-10-07 11:57:00],
        user_id: user.id
      })
      |> TimeManager.Time.create_clock()
    clock
  end
end
