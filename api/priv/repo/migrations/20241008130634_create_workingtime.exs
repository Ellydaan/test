defmodule TimeManager.Repo.Migrations.CreateWorkingtime do
  use Ecto.Migration

  def change do
    create table(:workingtime) do
      add :start, :naive_datetime
      add :end, :naive_datetime

      timestamps(type: :utc_datetime)
    end
  end
end
