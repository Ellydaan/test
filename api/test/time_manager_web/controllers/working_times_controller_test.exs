defmodule TimeManagerWeb.WorkingTimesControllerTest do
  use TimeManagerWeb.ConnCase

  import TimeManager.GuardianTestHelper
  import TimeManager.WorkingTimeFixtures
  import TimeManager.UsersFixtures
  alias TimeManager.WorkingTime.WorkingTimes

  @create_attrs %{
    start: ~N[2024-10-07 13:06:00],
    end: ~N[2024-10-07 13:06:00],
  }
  @update_attrs %{
    start: ~N[2024-10-08 13:06:00],
    end: ~N[2024-10-08 13:06:00],
  }

  @invalid_attrs %{start: nil, end: nil, user_id: nil}

  setup %{conn: conn} do
    user = user_fixture();
    {:ok, conn: conn, user: user}
  end

  describe "index" do
    test "lists all workingtime by user", %{conn: conn, user: user} do
      authed_connexion = setup_authenticated_conn(conn, user)
      conn = get(authed_connexion, ~p"/api/working_times/#{user.id}")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create working_times" do
    test "renders working_times when data is valid", %{conn: conn, user: user} do
      authed_connexion = setup_authenticated_conn(conn, user)
      conn = post(authed_connexion, ~p"/api/working_times/#{user.id}", working_times: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(authed_connexion, ~p"/api/working_times/#{user.id}/#{id}")
      working_time = Jason.decode(conn.resp_body)
      assert working_time = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      authed_connexion = setup_authenticated_conn(conn, user)
      conn = post(authed_connexion, ~p"/api/working_times/#{user.id}", working_times: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end
end
