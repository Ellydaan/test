defmodule TimeManagerWeb.DefaultController do
    use TimeManagerWeb, :controller

    def index(conn, _params) do
        text conn, "The Time Manager API is LIVE - #{Mix.env()}"
    end
    
end