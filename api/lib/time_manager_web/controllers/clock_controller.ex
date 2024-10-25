defmodule TimeManagerWeb.ClockController do
  use TimeManagerWeb, :controller
  require Logger

  alias TimeManager.Time
  alias TimeManager.Time.Clock

  action_fallback TimeManagerWeb.FallbackController

  def index(conn, _params) do
    clocks = Time.list_clocks(_params)
    render(conn, :index, clocks: clocks)
  end

  def create(conn, %{"clocks" => clock_params}) do
    clock = Map.put(clock_params, "user_id", conn.params["userID"])
    with {:ok, %Clock{} = clock} <- Time.create_clock(clock) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/clocks/#{clock}")
      |> render(:show, clock: clock)
    end
  end

#  def show(conn, %{"id" => id}) do
#    clock = Time.get_clock!(id)
#    render(conn, :show, clock: clock)
#  end
#
#  def update(conn, %{"id" => id, "clock" => clock_params}) do
#    clock = Time.get_clock!(id)
#
#    with {:ok, %Clock{} = clock} <- Time.update_clock(clock, clock_params) do
#      render(conn, :show, clock: clock)
#    end
#  end
#
#  def delete(conn, %{"id" => id}) do
#    clock = Time.get_clock!(id)
#
#    with {:ok, %Clock{}} <- Time.delete_clock(clock) do
#      send_resp(conn, :no_content, "")
#    end
#  end

  def showChartData(conn, params) do
    data = Time.chart_is_working_users()
    render(conn, :showChartData, data: data)
  end

  def showLastClock(conn, params) do
    clock = Time.get_last_clock(params["userID"])
    render(conn, :show, clock: clock)
  end
end
