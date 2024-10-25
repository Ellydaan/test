defmodule TimeManager.Time do
  @moduledoc """
  The Time context.
  """

  import Ecto.Query, warn: false
  alias TimeManager.Repo
  require Logger
  alias TimeManager.Time.Clock
  alias TimeManager.Users.User

  @doc """
  Returns the list of clocks.

  ## Examples

      iex> list_clocks()
      [%Clock{}, ...]

  """
  def list_clocks(params) do
    Clock
    |> where(user_id: ^params["userID"])
    |> Repo.all()
  end

  @doc """
  Gets a single clock.

  Raises `Ecto.NoResultsError` if the Clock does not exist.

  ## Examples

      iex> get_clock!(123)
      %Clock{}

      iex> get_clock!(456)
      ** (Ecto.NoResultsError)

  """
  def get_clock!(id), do: Repo.get!(Clock, id)

  @doc """
  Creates a clock.

  ## Examples

      iex> create_clock(%{field: value})
      {:ok, %Clock{}}

      iex> create_clock(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_clock(attrs \\ %{}) do
    %Clock{}
    |> Clock.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a clock.

  ## Examples

      iex> update_clock(clock, %{field: new_value})
      {:ok, %Clock{}}

      iex> update_clock(clock, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_clock(%Clock{} = clock, attrs) do
    clock
    |> Clock.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a clock.

  ## Examples

      iex> delete_clock(clock)
      {:ok, %Clock{}}

      iex> delete_clock(clock)
      {:error, %Ecto.Changeset{}}

  """
  def delete_clock(%Clock{} = clock) do
    Repo.delete(clock)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking clock changes.

  ## Examples

      iex> change_clock(clock)
      %Ecto.Changeset{data: %Clock{}}

  """
  def change_clock(%Clock{} = clock, attrs \\ %{}) do
    Clock.changeset(clock, attrs)
  end

  def chart_is_working_users() do
    last_clocks_query = from c in Clock,
                             select: %{
                               user_id: c.user_id,
                               time: c.time,
                               status: c.status,
                               row_number: over(row_number(), partition_by: c.user_id, order_by: [desc: c.time])
                             }

    query = from u in User,
                 left_join: c in subquery(last_clocks_query),
                 on: u.id == c.user_id and c.row_number == 1,
                 select: c.status,
                 order_by: [asc: u.id]

    results = Repo.all(query)
    Logger.info("Results: #{inspect(results)}")
    working_count = Enum.count(results, &(&1 == true))
    not_working_count = Enum.count(results, &(&1 == false))

    %{
      "working_users" => working_count,
      "not_working_users" => not_working_count
    }
  end

  def chart_hours_worked_last_week(user_id) do
    user_id = String.to_integer(user_id)
    query = """
      WITH date_series AS (
          SELECT generate_series(
                                 CURRENT_DATE - INTERVAL '6 days',
                                 CURRENT_DATE,
                                 '1 day'::interval
                 )::date AS work_date
      )
      SELECT
          ds.work_date,
          COALESCE(SUM(EXTRACT(EPOCH FROM (w."end" - w.start)) / 3600), 0) as hours_worked
      FROM
          date_series ds
              LEFT JOIN workingtime w ON DATE(w.start) = ds.work_date AND w.user_id = $1::integer
      GROUP BY
          ds.work_date
      ORDER BY
          ds.work_date ASC;
  """
    %Postgrex.Result{rows: rows} = Repo.query!(query, [user_id])
    rows
  end

  def get_last_clock(user_id) do
    user_id = String.to_integer(user_id)
    query = from c in Clock,
                where: c.user_id == ^user_id,
                order_by: [desc: c.time],
                limit: 1,
                select: c
    Repo.one(query)
  end
end
