defmodule TimeManager.Repo.Migrations.UsersWorkingtime do
  use Ecto.Migration

  def up do
    alter table(:workingtime) do
      add :user_id, references(:users, on_delete: :delete_all)
    end
  end

  def down do
    alter table(:workingtime) do
      remove :user_id
    end
  end
end
