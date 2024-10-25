defmodule TimeManager.Teams do
  @moduledoc """
  The Teams context.
  """

  import Ecto.Query, warn: false
  alias TimeManager.Repo

  alias TimeManager.Teams.Team
  alias TimeManager.Users.User
  @doc """
  Returns the list of teams.

  ## Examples

      iex> list_teams()
      [%Team{}, ...]

  """
  def list_teams do
    Repo.all(Team)
    |> Repo.preload([:members, :manager])
  end

  def list_teams(params) do
    manager_id = params["manager_id"]
    Repo.preload(:members)
    Repo.all(from t in Team, where: t.manager_id == ^manager_id)
  end

  @doc """
  Gets a single team.

  Raises `Ecto.NoResultsError` if the Team does not exist.

  ## Examples

      iex> get_team!(123)
      %Team{}

      iex> get_team!(456)
      ** (Ecto.NoResultsError)

  """
  def get_team!(id), do: Repo.get!(Team, id)

  @doc """
  Creates a team.

  ## Examples

      iex> create_team(%{field: value})
      {:ok, %Team{}}

      iex> create_team(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_team(attrs \\ %{}) do
    %Team{}
    |> Team.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a team.

  ## Examples

      iex> update_team(team, %{field: new_value})
      {:ok, %Team{}}

      iex> update_team(team, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_team(%Team{} = team, attrs) do
    team
    |> Team.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a team.

  ## Examples

      iex> delete_team(team)
      {:ok, %Team{}}

      iex> delete_team(team)
      {:error, %Ecto.Changeset{}}

  """
  def delete_team(%Team{} = team) do
    Repo.delete(team)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking team changes.

  ## Examples

      iex> change_team(team)
      %Ecto.Changeset{data: %Team{}}

  """
  def change_team(%Team{} = team, attrs \\ %{}) do
    Team.changeset(team, attrs)
  end

  def add_member(%Team{} = team, %User{} = user) do
    team = Repo.preload(team, :members)

    unless Enum.any?(team.members, fn member -> member.id == user.id end) do
      now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)

      Repo.insert_all("team_members", [
        %{team_id: team.id, user_id: user.id, inserted_at: now, updated_at: now}
      ])
      {:ok, %{team | members: [user | team.members]}}
    else
      {:ok, team}
    end
  end

  def remove_member(%Team{} = team, %User{} = user) do
    team
    |> Repo.preload(:members)
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put_assoc(:members, Enum.filter(team.members, &(&1.id != user.id)))
    |> Repo.update()
  end

  def list_team_members(team_id) do
    Team
    |> where([t], t.id == ^team_id)
    |> preload(:members)
    |> Repo.one()
    |> Map.get(:members, [])
  end
end
