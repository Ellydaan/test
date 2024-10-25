defmodule TimeManager.WorkingTime do
  @moduledoc """
  The WorkingTime context.
  """
  require Logger
  import Ecto.Query, warn: false
  alias TimeManager.Repo

  alias TimeManager.WorkingTime.WorkingTimes

  @doc """
  Returns the list of workingtime.

  ## Examples

      iex> list_workingtime()
      [%WorkingTimes{}, ...]

  """
  def list_workingtime(params) do
    query = from w in WorkingTimes,
      where: w.user_id == ^params["userID"]

    query = if params["start"] do
      {:ok, start_date} = Date.from_iso8601(params["start"])
      {:ok, start_date_time} = NaiveDateTime.from_iso8601("#{Date.to_string(start_date)}T00:00:00Z")
      where(query, [w], w.start >= ^start_date_time)
    else
      query
    end

    query = if params["end"] do
      {:ok, end_date} = Date.from_iso8601(params["end"])
      {:ok, end_date_time} = NaiveDateTime.from_iso8601("#{Date.to_string(end_date)}T23:59:59Z")
      where(query, [w], w.end <= ^end_date_time)
    else
      query
    end

    Repo.all(query)
  end

  @doc """
  Gets a single working_times.

  Raises `Ecto.NoResultsError` if the Working times does not exist.

  ## Examples

      iex> get_working_times!(123)
      %WorkingTimes{}

      iex> get_working_times!(456)
      ** (Ecto.NoResultsError)

  """
  def get_working_times!(userID, id) do
    query = from w in WorkingTimes,
      where: w.id == ^id,
      where: w.user_id == ^userID,
      select: w
     Repo.one(query)
  end

  def get_working_times!(id) do
     Repo.get!(WorkingTimes, id)
  end

  @doc """
  Creates a working_times.

  ## Examples

      iex> create_working_times(%{field: value})
      {:ok, %WorkingTimes{}}

      iex> create_working_times(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_working_times(attrs \\ %{}) do
    %WorkingTimes{}
    |> WorkingTimes.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a working_times.

  ## Examples

      iex> update_working_times(working_times, %{field: new_value})
      {:ok, %WorkingTimes{}}

      iex> update_working_times(working_times, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_working_times(%WorkingTimes{} = working_times, attrs) do
    working_times
    |> WorkingTimes.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a working_times.

  ## Examples

      iex> delete_working_times(working_times)
      {:ok, %WorkingTimes{}}

      iex> delete_working_times(working_times)
      {:error, %Ecto.Changeset{}}

  """
  def delete_working_times(%WorkingTimes{} = working_times) do
    Repo.delete(working_times)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking working_times changes.

  ## Examples

      iex> change_working_times(working_times)
      %Ecto.Changeset{data: %WorkingTimes{}}

  """
  def change_working_times(%WorkingTimes{} = working_times, attrs \\ %{}) do
    WorkingTimes.changeset(working_times, attrs)
  end
end
