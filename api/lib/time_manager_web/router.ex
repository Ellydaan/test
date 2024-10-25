defmodule TimeManagerWeb.Router do
  use TimeManagerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug TimeManagerWeb.AuthPipeline
  end

  # PUBLIC API ROUTES
  scope "/api", TimeManagerWeb do
    pipe_through :api

    # AUTH
    post "/register", AuthController, :register
    post "/login", AuthController, :login
    post "/logout", AuthController, :logout
  end

  # PRIVATE API ROUTES
  scope "/api", TimeManagerWeb do
    pipe_through [:api, :auth]

    get "/", DefaultController, :index

    # USERS
    resources "/users", UserController, except: [:new, :edit]

    # CLOCKS
    scope "/clocks" do
      get "/:userID", ClockController, :index
      post "/:userID", ClockController, :create
      get "/:userID/last", ClockController, :showLastClock
    end

    # WORKING TIMES
    scope "/working_times" do
      get "/:userID", WorkingTimesController, :index
      post "/:userID", WorkingTimesController, :create
      get "/:userID/:id", WorkingTimesController, :show
      put "/:id", WorkingTimesController, :update
      delete "/:id", WorkingTimesController, :delete
    end

    # CHART
    scope "/chartManager" do
      get "/is_working/users", ChartController, :showChartData
      get "/:userID", ChartController, :showHoursWorkedLastWeek
    end

    # TEAMS
    resources "/teams", TeamController, except: [:new, :edit]
    post "/teams/:id/add_member/:user_id", TeamController, :add_member
    post "/teams/:id/remove_member/:user_id", TeamController, :remove_member

    # MANAGER
    scope "/manager" do
      get "/:manager_id/teams", TeamController, :showMyTeams
    end
  end

end
