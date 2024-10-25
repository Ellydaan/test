defmodule TimeManager.TeamsTest do
  use TimeManager.DataCase

  alias TimeManager.Teams

  import TimeManager.UsersFixtures
  import TimeManager.TeamsFixtures

  describe "teams" do
    alias TimeManager.Teams.Team

    @invalid_attrs %{name: nil, manager_id: nil}

    test "get_team!/1 returns the team with given id" do
      team = create_team()
      assert Teams.get_team!(team.id) == team
    end

    test "create_team/1 with valid data creates a team" do
      user = user_fixture(%{role: "manager"})
      valid_attrs = %{name: "some name", manager_id: user.id}

      assert {:ok, %Team{} = team} = Teams.create_team(valid_attrs)
      assert team.name == "some name"
    end

    test "create_team/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Teams.create_team(@invalid_attrs)
    end

    test "update_team/2 with valid data updates the team" do
      team = create_team()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Team{} = team} = Teams.update_team(team, update_attrs)
      assert team.name == "some updated name"
    end

    test "update_team/2 with invalid data returns error changeset" do
      team = create_team()
      assert {:error, %Ecto.Changeset{}} = Teams.update_team(team, @invalid_attrs)
      assert team == Teams.get_team!(team.id)
    end

    test "delete_team/1 deletes the team" do
      team = create_team()
      assert {:ok, %Team{}} = Teams.delete_team(team)
      assert_raise Ecto.NoResultsError, fn -> Teams.get_team!(team.id) end
    end

    test "change_team/1 returns a team changeset" do
      team = create_team()
      assert %Ecto.Changeset{} = Teams.change_team(team)
    end
  end

  def create_team() do
    user = user_fixture(%{email: "test@test.com", username: "t" ,  role: "manager"})
    team = team_fixture(%{manager_id: user.id})
  end
end
