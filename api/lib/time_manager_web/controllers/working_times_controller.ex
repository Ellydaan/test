defmodule TimeManagerWeb.WorkingTimesController do
  use TimeManagerWeb, :controller
  require Logger

  alias TimeManager.WorkingTime
  alias TimeManager.WorkingTime.WorkingTimes

  action_fallback TimeManagerWeb.FallbackController

  def index(conn, _params) do
    workingtime = WorkingTime.list_workingtime(_params)
    render(conn, :index, workingtime: workingtime)
  end

  def create(conn, %{"working_times" => working_times_params}) do
    working_times_params = Map.put(working_times_params, "user_id", conn.params["userID"])
    with {:ok, %WorkingTimes{} = working_times} <- WorkingTime.create_working_times(working_times_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/workingtime/#{working_times}")
      |> render(:show, working_times: working_times)
    end
  end

  def show(conn, %{"userID" => userID ,"id" => id}) do
    working_times = WorkingTime.get_working_times!(userID, id)
    render(conn, :show, working_times: working_times)
  end

  def update(conn, %{"id" => id, "working_times" => working_times_params}) do
    working_times = WorkingTime.get_working_times!(id)

    with {:ok, %WorkingTimes{} = working_times} <- WorkingTime.update_working_times(working_times, working_times_params) do
      render(conn, :show, working_times: working_times)
    end
  end

  def delete(conn, %{"id" => id}) do
    working_times = WorkingTime.get_working_times!(id)

    with {:ok, %WorkingTimes{}} <- WorkingTime.delete_working_times(working_times) do
      send_resp(conn, :no_content, "")
    end
  end
end
