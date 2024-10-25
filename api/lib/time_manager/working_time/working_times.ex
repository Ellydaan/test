defmodule TimeManager.WorkingTime.WorkingTimes do
  use Ecto.Schema
  import Ecto.Changeset

  schema "workingtime" do
    field :start, :naive_datetime
    field :end, :naive_datetime
    belongs_to :user, TimeManager.Users.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(working_times, attrs) do
    working_times
    |> cast(attrs, [:start, :end, :user_id])
    |> validate_required([:start, :end, :user_id])
    |> foreign_key_constraint(:user_id)
  end
end
