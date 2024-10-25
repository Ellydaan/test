defmodule TimeManagerWeb.TeamController do
  use TimeManagerWeb, :controller

  alias TimeManager.Teams
  alias TimeManager.Teams.Team
  alias TimeManager.Users

  action_fallback TimeManagerWeb.FallbackController

  def index(conn, _params) do
    teams = Teams.list_teams()
    render(conn, :index, teams: teams)
  end

  def create(conn, %{"team" => team_params}) do
    user = Users.get_user!(team_params["manager_id"])
    if user.role not in ["manager", "admin", "super_admin"] do
      conn
      |> put_status(:forbidden)
      |> json(%{error: "You don't have permission to create a team"})
    else
      with {:ok, %Team{} = team} <- Teams.create_team(team_params) do
        conn
        |> put_status(:created)
        |> put_resp_header("location", ~p"/api/teams/#{team}")
        |> render(:show, team: team)
      end
    end
  end

  def show(conn, %{"id" => id}) do
    team = Teams.get_team!(id)
    render(conn, :show, team: team)
  end

  def update(conn, %{"id" => id, "team" => team_params}) do
    team = Teams.get_team!(id)

    with {:ok, %Team{} = team} <- Teams.update_team(team, team_params) do
      render(conn, :show, team: team)
    end
  end

  def delete(conn, %{"id" => id}) do
    team = Teams.get_team!(id)

    with {:ok, %Team{}} <- Teams.delete_team(team) do
      send_resp(conn, :no_content, "")
    end
  end

  def add_member(conn, %{"id" => id, "user_id" => user_id}) do
    team = Teams.get_team!(id)
    user = Users.get_user!(user_id)

    with {:ok, %Team{} = team} <- Teams.add_member(team, user) do
      render(conn, :show, team: team)
    end
  end

  def remove_member(conn, %{"id" => id, "user_id" => user_id}) do
    team = Teams.get_team!(id)
    user = Users.get_user!(user_id)

    with {:ok, %Team{} = team} <- Teams.remove_member(team, user) do
      render(conn, :show, team: team)
    end
  end

  def showMyTeams(conn, _params) do
    teams = Teams.list_teams(_params)
    render(conn, :index, teams: teams)
  end
end
