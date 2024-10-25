defmodule TimeManagerWeb.TeamJSON do
  alias TimeManager.Teams.Team
  alias TimeManager.Users.User

  @doc """
  Renders a list of teams.
  """
  def index(%{teams: teams}) do
    %{data: for(team <- teams, do: data(team))}
  end

  @doc """
  Renders a single team.
  """
  def show(%{team: team}) do
    %{data: data(team)}
  end

  defp data(%Team{} = team) do
    %{
      id: team.id,
      name: team.name,
      manager_id: team.manager_id,
      members: render_members(team.members)
    }
  end

  defp render_members(members) when is_list(members) do
    Enum.map(members, &render_member/1)
  end

  defp render_members(_), do: []

  defp render_member(%User{} = user) do
    %{
      id: user.id,
      username: user.username,
      email: user.email
    }
  end
end
