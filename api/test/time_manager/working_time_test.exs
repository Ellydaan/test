defmodule TimeManager.WorkingTimeTest do
  use TimeManager.DataCase

  alias TimeManager.WorkingTime

  describe "workingtime" do
    alias TimeManager.WorkingTime.WorkingTimes

    import TimeManager.WorkingTimeFixtures
    import TimeManager.UsersFixtures

    @invalid_attrs %{start: nil, end: nil}

    test "list_workingtime/1 returns all workingtime" do
      working_times = working_times_fixture()
      assert WorkingTime.list_workingtime(%{"userID" => working_times.user_id}) == [working_times]
    end

    test "get_working_times!/1 returns the working_times with given id" do
      working_times = working_times_fixture()
      assert WorkingTime.get_working_times!(working_times.id) == working_times
    end

    test "create_working_times/1 with valid data creates a working_times" do
      user = user_fixture()
      valid_attrs = %{start: ~N[2024-10-07 13:06:00], end: ~N[2024-10-07 13:06:00], user_id: user.id}

      assert {:ok, %WorkingTimes{} = working_times} = WorkingTime.create_working_times(valid_attrs)
      assert working_times.start == ~N[2024-10-07 13:06:00]
      assert working_times.end == ~N[2024-10-07 13:06:00]
      assert working_times.user_id == user.id
    end

    test "create_working_times/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = WorkingTime.create_working_times(@invalid_attrs)
    end

    test "update_working_times/2 with valid data updates the working_times" do
      working_times = working_times_fixture()
      update_attrs = %{start: ~N[2024-10-08 13:06:00], end: ~N[2024-10-08 13:06:00]}

      assert {:ok, %WorkingTimes{} = working_times} = WorkingTime.update_working_times(working_times, update_attrs)
      assert working_times.start == ~N[2024-10-08 13:06:00]
      assert working_times.end == ~N[2024-10-08 13:06:00]
    end

    test "update_working_times/2 with invalid data returns error changeset" do
      working_times = working_times_fixture()
      assert {:error, %Ecto.Changeset{}} = WorkingTime.update_working_times(working_times, @invalid_attrs)
      assert working_times == WorkingTime.get_working_times!(working_times.id)
    end

    test "delete_working_times/1 deletes the working_times" do
      working_times = working_times_fixture()
      assert {:ok, %WorkingTimes{}} = WorkingTime.delete_working_times(working_times)
      assert_raise Ecto.NoResultsError, fn -> WorkingTime.get_working_times!(working_times.id) end
    end

    test "change_working_times/1 returns a working_times changeset" do
      working_times = working_times_fixture()
      assert %Ecto.Changeset{} = WorkingTime.change_working_times(working_times)
    end
  end
end
