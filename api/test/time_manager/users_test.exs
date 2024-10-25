defmodule TimeManager.UsersTest do
  use TimeManager.DataCase

  alias TimeManager.Users

  describe "users" do
    alias TimeManager.Users.User

    import TimeManager.UsersFixtures

    @invalid_attrs %{username: nil, email: nil, password: nil}

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Users.list_user() == [user]
    end

    test "list_users/1 returns all users with email params" do
      user = user_fixture()
      assert Users.list_user(%{"email" => "test"}) == [user]
    end

    test "list_users/1 returns all users with username params" do
      user = user_fixture()
      assert Users.list_user(%{"username" => "test"}) == []
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Users.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{username: "test_username_create", email: "test_create@test.test", password: "test_password"}

      assert {:ok, %User{} = user} = Users.create_user(valid_attrs)
      assert user.username == "test_username_create"
      assert user.email == "test_create@test.test"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Users.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      update_attrs = %{username: "test_username_update", email: "test2@test.test", password: "test_update_password"}

      assert {:ok, %User{} = user} = Users.update_user(user, update_attrs)
      assert user.username == "test_username_update"
      assert user.email == "test2@test.test"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Users.update_user(user, @invalid_attrs)
      assert user == Users.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Users.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Users.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Users.change_user(user)
    end
  end
end
