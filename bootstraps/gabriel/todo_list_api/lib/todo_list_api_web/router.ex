defmodule TodoListApiWeb.Router do
  use TodoListApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", TodoListApiWeb do
    pipe_through :api
  end
end
