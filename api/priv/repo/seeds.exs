# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     TimeManager.Repo.insert!(%TimeManager.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
# priv/repo/seeds.exs

defmodule TimeManager.Seeds do
  alias TimeManager.Repo
  alias TimeManager.Users.User
  alias TimeManager.Time.Clock
  alias TimeManager.WorkingTime.WorkingTimes

  require Logger

  def run do
    try do
      # Remove all existing records
      Repo.delete_all(WorkingTimes)
      Repo.delete_all(Clock)
      Repo.delete_all(User)

      # Create sample users
      users = [
        %{username: "john_doe", email: "john.doe@example.com"},
        %{username: "jane_smith", email: "jane.smith@example.com"},
        %{username: "bob_johnson", email: "bob.johnson@example.com"},
        %{username: "alice_williams", email: "alice.williams@example.com"},
        %{username: "charlie_brown", email: "charlie.brown@example.com"}
      ]

      created_users = Enum.map(users, fn user_data ->
        {:ok, user} = create_user(user_data)
        user
      end)

      # Create sample clocks and working times for each user
      Enum.each(created_users, fn user ->
        # Create 3 clock entries for each user
        for i <- 1..3 do
          create_clock(user, i)
        end

        # Create 2 working time entries for each user
        for i <- 1..2 do
          create_working_time(user, i)
        end
      end)

      Logger.info("Seeding completed successfully!")
    rescue
      e ->
        Logger.error("An error occurred during seeding: #{inspect(e)}")
        Logger.error(Exception.format_stacktrace())
    end
  end

  defp create_user(user_data) do
    %User{}
    |> User.changeset(user_data)
    |> Repo.insert()
    |> case do
      {:ok, user} ->
        Logger.info("Created user: #{user.username}")
        {:ok, user}
      {:error, changeset} ->
        Logger.error("Failed to create user: #{inspect(changeset.errors)}")
        {:error, changeset}
    end
  end

  defp create_clock(user, i) do
    %Clock{}
    |> Clock.changeset(%{
      status: rem(i, 2) == 0,
      time: NaiveDateTime.utc_now() |> NaiveDateTime.add(-i * 86400, :second),
      user_id: user.id
    })
    |> Repo.insert()
    |> case do
      {:ok, clock} ->
        Logger.info("Created clock for user #{user.username}: #{clock.time}")
      {:error, changeset} ->
        Logger.error("Failed to create clock for user #{user.username}: #{inspect(changeset.errors)}")
    end
  end

  defp create_working_time(user, i) do
    start_time = NaiveDateTime.utc_now() |> NaiveDateTime.add(-i * 86400, :second)
    end_time = start_time |> NaiveDateTime.add(28800, :second)  # 8 hours later

    %WorkingTimes{}
    |> WorkingTimes.changeset(%{
      start: start_time,
      end: end_time,
      user_id: user.id
    })
    |> Repo.insert()
    |> case do
      {:ok, working_time} ->
        Logger.info("Created working time for user #{user.username}: #{working_time.start} to #{working_time.end}")
      {:error, changeset} ->
        Logger.error("Failed to create working time for user #{user.username}: #{inspect(changeset.errors)}")
    end
  end
end

# Run the seeder
TimeManager.Seeds.run()