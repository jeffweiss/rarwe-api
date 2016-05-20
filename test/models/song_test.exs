defmodule Rarwe.SongTest do
  use Rarwe.ModelCase

  alias Rarwe.Song

  @valid_attrs %{rating: 42, title: "some content", band_id: 1}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Song.changeset(%Song{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Song.changeset(%Song{}, @invalid_attrs)
    refute changeset.valid?
  end
end
