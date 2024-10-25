defmodule TimeManager.Repo.Migrations.CreateTeamMembers do
  use Ecto.Migration

  def up do
    create table(:team_members) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :team_id, references(:teams, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:team_members, [:user_id])
    create index(:team_members, [:team_id])
    create unique_index(:team_members, [:user_id, :team_id])
  end

  def down do
    drop table(:team_members)
  end
end