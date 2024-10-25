defmodule TimeManager.Teams.Team do
  use Ecto.Schema
  import Ecto.Changeset

  schema "teams" do
    field :name, :string
    belongs_to :manager, TimeManager.Users.User
    many_to_many :members, TimeManager.Users.User, join_through: "team_members"

    timestamps()
  end

  @doc false
  def changeset(team, attrs) do
    team
    |> cast(attrs, [:name, :manager_id])
    |> validate_required([:name, :manager_id])
    |> unique_constraint(:name)
    |> foreign_key_constraint(:manager_id)
  end
end