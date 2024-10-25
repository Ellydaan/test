defmodule TimeManager.TimeTest do
  use TimeManager.DataCase

  alias TimeManager.Time

  describe "clocks" do
    alias TimeManager.Time.Clock

    import TimeManager.TimeFixtures
    import TimeManager.UsersFixtures

    @invalid_attrs %{status: nil, time: nil, user_id: nil}


    test "list_clocks/0 returns all clocks" do
      clock = clock_fixture()
      assert Time.list_clocks(%{"userID" => clock.user_id}) == [clock]
    end

    test "create_clock/1 with valid data creates a clock" do
      user = user_fixture()
      valid_attrs = %{status: true, time: ~N[2024-10-07 11:57:00], user_id: user.id}

      assert {:ok, %Clock{} = clock} = Time.create_clock(valid_attrs)
      assert clock.status == true
      assert clock.time == ~N[2024-10-07 11:57:00]
      assert clock.user_id == user.id
    end

    test "create_clock/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Time.create_clock(@invalid_attrs)
    end

    test "update_clock/2 with valid data updates the clock" do
      clock = clock_fixture()
      update_attrs = %{status: false, time: ~N[2024-10-08 11:57:00]}

      assert {:ok, %Clock{} = clock} = Time.update_clock(clock, update_attrs)
      assert clock.status == false
      assert clock.time == ~N[2024-10-08 11:57:00]
    end

    test "update_clock/2 with invalid data returns error changeset" do
      clock = clock_fixture()
      assert {:error, %Ecto.Changeset{}} = Time.update_clock(clock, @invalid_attrs)
      assert clock == Time.get_clock!(clock.id)
    end

    test "delete_clock/1 deletes the clock" do
      clock = clock_fixture()
      assert {:ok, %Clock{}} = Time.delete_clock(clock)
      assert_raise Ecto.NoResultsError, fn -> Time.get_clock!(clock.id) end
    end

    test "change_clock/1 returns a clock changeset" do
      clock = clock_fixture()
      assert %Ecto.Changeset{} = Time.change_clock(clock)
    end
  end
end
