defmodule Rarwe.BandView do
  use Rarwe.Web, :view
  use JaSerializer.PhoenixView

  attributes [:name, :description]
  has_many :songs, link: :songs_link

  def songs_link(band, conn) do
    band_song_url(conn, :index, band)
  end
end
