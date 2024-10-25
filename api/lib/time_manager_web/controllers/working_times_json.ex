defmodule TimeManagerWeb.WorkingTimesJSON do
  alias TimeManager.WorkingTime.WorkingTimes

  @doc """
  Renders a list of workingtime.
  """
  def index(%{workingtime: workingtime}) do
    %{data: for(working_times <- workingtime, do: data(working_times))}
  end

  @doc """
  Renders a single working_times.
  """
  def show(%{working_times: working_times}) do
    %{data: data(working_times)}
  end

  defp data(%WorkingTimes{} = working_times) do
    Jason.OrderedObject.new([
      {:id, working_times.id},
      {:start, working_times.start},
      {:end, working_times.end}
    ])
  end
end