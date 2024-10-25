defmodule TimeManagerWeb.UserControllerTest do
  use TimeManagerWeb.ConnCase

  import TimeManager.GuardianTestHelper
  import TimeManager.UsersFixtures

  alias TimeManager.Users.User

  @create_attrs %{
    username: "test_username",
    email: "test@test.test",
    password: "test_password"
  }
  @update_attrs %{
    username: "test_updated_username",
    email: "test_updated@test.test",
    password: "test_updated_password"
  }
  @invalid_attrs %{username: nil, email: nil, password: nil}

  setup %{conn: conn} do
    user = user_fixture();
    {:ok, conn: conn, user: user}
  end

  describe "index" do
    test "lists all users", %{conn: conn, user: user} do
      authed_connexion = setup_authenticated_conn(conn, user)
      conn = get(authed_connexion, ~p"/api/users")
      assert json_response(conn, 200)["data"] == [%{ "email" => user.email, "id" => user.id, "username" => user.username }]
    end
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn, user: user} do
      authed_connexion = setup_authenticated_conn(conn, user)
      conn = post(authed_connexion, ~p"/api/users", user: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(authed_connexion, ~p"/api/users/#{id}")

      assert %{
               "id" => ^id,
               "email" => "test@test.test",
               "username" => "test_username"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      authed_connexion = setup_authenticated_conn(conn, user)
      conn = post(authed_connexion, ~p"/api/users", user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update user" do
    setup [:create_user]

    test "renders user when data is valid", %{conn: conn, user: %User{id: id} = user} do
      authed_connexion = setup_authenticated_conn(conn, user)
      conn = put(authed_connexion, ~p"/api/users/#{user}", user: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(authed_connexion, ~p"/api/users/#{id}")

      assert %{
               "id" => ^id,
               "email" => "test_updated@test.test",
               "username" => "test_updated_username"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      authed_connexion = setup_authenticated_conn(conn, user)
      conn = put(authed_connexion, ~p"/api/users/#{user}", user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete user" do

    test "deletes chosen user", %{conn: conn, user: user} do
      test_user = user_fixture_test()
      authed_connexion = setup_authenticated_conn(conn, user)
      conn = delete(authed_connexion, ~p"/api/users/#{test_user}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(authed_connexion, ~p"/api/users/#{test_user}")
      end
    end
  end

  defp create_user(_) do
    user = user_fixture_test()
    %{user: user}
  end
end
