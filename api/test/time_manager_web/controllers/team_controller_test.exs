defmodule TimeManagerWeb.TeamControllerTest do
  use TimeManagerWeb.ConnCase

  import TimeManager.GuardianTestHelper
  import TimeManager.TeamsFixtures
  import TimeManager.UsersFixtures

  alias TimeManager.Teams.Team

  @create_attrs %{
    name: "some name"
  }
  @update_attrs %{
    name: "some updated name"
  }
  @invalid_attrs %{name: nil, manager_id: nil}

  setup %{conn: conn} do
    user = user_fixture();
    {:ok, conn: conn, user: user}
  end

  describe "index" do
    test "lists all teams", %{conn: conn, user: user} do
      authed_connexion = setup_authenticated_conn(conn, user)
      conn = get(authed_connexion, ~p"/api/teams")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create team" do
    test "renders team when data is valid", %{conn: conn} do
      user = user_fixture_test(%{role: "manager"})
      authed_connexion = setup_authenticated_conn(conn, user)
      conn = post(authed_connexion, ~p"/api/teams", team: %{"name" => "some name", "manager_id" => user.id} )
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(authed_connexion, ~p"/api/teams/#{id}")

      assert %{
               "id" => ^id,
               "name" => "some name",
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when user is not a manager", %{conn: conn, user: user} do
      authed_connexion = setup_authenticated_conn(conn, user)
      conn = post(authed_connexion, ~p"/api/teams", team: %{"name" => "some name", "manager_id" => user.id} )
      assert json_response(conn, 403) != %{}
      assert json_response(conn, 403) == %{"error" => "You don't have permission to create a team"}
    end

  end

  describe "update team" do
    setup [:create_team]

    test "renders team when data is valid", %{conn: conn, team: %Team{id: id} = team} do
      user = user_fixture_test(%{role: "manager"})
      authed_connexion = setup_authenticated_conn(conn, user)
      conn = put(authed_connexion, ~p"/api/teams/#{team}", team: %{"name" => "some name", "manager_id" => user.id})
      assert %{"id" => ^id} = json_response(conn, 200)["data"]
      {_, updated_team} = Jason.decode(conn.resp_body)
      data = updated_team["data"]
      conn = get(authed_connexion, ~p"/api/teams/#{id}")


      assert data = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, user: user, team: team} do
      authed_connexion = setup_authenticated_conn(conn, user)
      conn = put(authed_connexion, ~p"/api/teams/#{team}", team: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete team" do
    setup [:create_team]

    test "deletes chosen team", %{conn: conn, user: user, team: team} do
      authed_connexion = setup_authenticated_conn(conn, user)
      conn = delete(authed_connexion, ~p"/api/teams/#{team}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(authed_connexion, ~p"/api/teams/#{team}")
      end
    end
  end

  defp create_team(_) do
    user = user_fixture(%{email: "test@test.com", username: "t" ,  role: "manager"})
    team = team_fixture(%{manager_id: user.id})
    %{team: team}
  end
end
