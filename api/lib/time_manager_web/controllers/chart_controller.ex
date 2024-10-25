defmodule TimeManagerWeb.ChartController do
  use TimeManagerWeb, :controller

  alias TimeManager.Time
  alias TimeManager.Time.Clock

  action_fallback TimeManagerWeb.FallbackController

  def showChartData(conn, params) do
    data = Time.chart_is_working_users()
    render(conn, :showChartData, data: data)
  end

  def showHoursWorkedLastWeek(conn, params) do
    data = Time.chart_hours_worked_last_week(params["userID"])
    render(conn, :showHoursWorkedLastWeek, data: data)
  end
end
