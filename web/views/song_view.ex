defmodule Rarwe.SongView do
  use Rarwe.Web, :view
  use JaSerializer.PhoenixView

  attributes [:title, :rating]
  # has_one :band, links: [related: "/bands/:band_id"]
  def type, do: "songs"
end
