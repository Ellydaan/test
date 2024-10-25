defmodule TimeManager.Repo.Migrations.AddRoleToUsers do
  use Ecto.Migration

  def up do
    alter table(:users) do
      add :role, :string, default: "user"
    end

    create index(:users, [:role])
  end

  def down do
    alter table(:users) do
      remove :role
    end

    drop index(:users, [:role])
  end
end