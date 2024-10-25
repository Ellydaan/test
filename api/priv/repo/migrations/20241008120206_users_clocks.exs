defmodule TimeManager.Repo.Migrations.UsersClocks do
  use Ecto.Migration

  def up do
    alter table(:clocks) do
      add :user_id, references(:users, on_delete: :delete_all)
    end
  end

  def down do
    alter table(:clocks) do
      remove :user_id
    end
  end
end
