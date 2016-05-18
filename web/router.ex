defmodule Rarwe.Router do
  use Rarwe.Web, :router

  pipeline :api do
    plug :accepts, ["json", "json-api"]
  end

  scope "/api", Rarwe do
    pipe_through :api
    resources "/bands", BandController, except: [:new, :edit] do
      resources "/songs", SongController, except: [:new, :edit]
    end
    resources "/songs", SongController, except: [:new, :edit]
  end
end
