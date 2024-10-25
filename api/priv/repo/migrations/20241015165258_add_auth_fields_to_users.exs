defmodule TimeManager.Repo.Migrations.AddAuthFieldsToUsers do
  use Ecto.Migration

  def up do
    alter table(:users) do
      add :password_hash, :string
    end

    create unique_index(:users, [:email])
  end

  def down do
    alter table(:users) do
      remove :password_hash
    end

    drop unique_index(:users, [:email])
  end
end