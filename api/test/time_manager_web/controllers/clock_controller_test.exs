defmodule TimeManagerWeb.ClockControllerTest do
  use TimeManagerWeb.ConnCase

  import TimeManager.GuardianTestHelper
  import TimeManager.TimeFixtures
  import TimeManager.UsersFixtures


  alias TimeManager.Time.Clock
  alias TimeManager.Users
  alias TimeManager.Users.User

  @create_attrs %{
    status: true,
    time: ~N[2024-10-07 11:57:00],
  }

  @update_attrs %{
    status: false,
    time: ~N[2024-10-08 11:57:00],
    user_id: 1
  }
  @invalid_attrs %{status: nil, time: nil}

  setup %{conn: conn} do
    user = user_fixture();
    {:ok, conn: conn, user: user}
  end

  describe "index" do
    test "lists all clocks by user id", %{conn: conn, user: user} do
      authed_connexion = setup_authenticated_conn(conn, user)

      conn = get(authed_connexion, ~p"/api/clocks/#{user.id}")

      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create clock" do
    test "renders clock when data is valid", %{conn: conn, user: user} do

      authed_connexion = setup_authenticated_conn(conn, user)

      conn = post(authed_connexion, ~p"/api/clocks/#{user.id}", clocks: @create_attrs)

      {_, clock} = Jason.decode(conn.resp_body)
      data = clock["data"]

      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(authed_connexion, ~p"/api/clocks/#{user.id}")

      assert data = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      authed_connexion = setup_authenticated_conn(conn, user)
      conn = post(authed_connexion, ~p"/api/clocks/1", clocks: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  defp create_clock(_) do
    clock = clock_fixture()
    %{clock: clock}
  end
end
