defmodule Rarwe.Router do
  use Rarwe.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", Rarwe do
    pipe_through :api
  end
end
