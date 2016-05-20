defmodule Rarwe.SongControllerTest do
  use Rarwe.ConnCase

  alias Rarwe.{Band, Song}
  @valid_attrs %{rating: 42, title: "some content"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    band = Repo.insert! %Band{name: "wat", description: "test band"}
    create_test_songs(band)
    {:ok, conn: put_req_header(conn, "accept", "application/json"), band: band}
  end

  def create_test_songs(band) do
    for title <- ["First Song", "Second Song", "Third Song"] do
      Repo.insert! %Song{band_id: band.id, title: title}
    end

    other_band = Repo.insert! %Band{name: "other band"}
    for title <- ["Fourth Song", "Fifth Song"] do
      Repo.insert! %Song{band_id: other_band.id, title: title}
    end
  end

  test "lists all songs for a band", %{conn: conn, band: band} do
    conn = get conn, band_song_path(conn, :index, band)
    assert Enum.count(json_response(conn, 200)["data"]) == 3
  end

  test "list all songs", %{conn: conn} do
    conn = get conn, song_path(conn, :index)
    assert Enum.count(json_response(conn, 200)["data"]) == 5
  end

  test "shows chosen resource for a band", %{conn: conn, band: band} do
    song = Repo.insert! %Song{band_id: band.id}
    conn = get conn, band_song_path(conn, :show, band, song)
    assert json_response(conn, 200)["data"] == %{
      "type" => "songs",
      "id" => to_string(song.id),
      "attributes" => %{
        "title" => song.title,
        "rating" => song.rating,
      }
    }
  end
  test "shows chosen resource", %{conn: conn} do
    song = Repo.insert! %Song{}
    conn = get conn, song_path(conn, :show, song)
    assert json_response(conn, 200)["data"] == %{
      "type" => "songs",
      "id" => to_string(song.id),
      "attributes" => %{
        "title" => song.title,
        "rating" => song.rating,
      }
    }
  end
  test "does not show valid song for wrong band", %{conn: conn, band: band} do
    song = Repo.insert! %Song{}
    assert_error_sent 404, fn ->
      get conn, band_song_path(conn, :show, band, song)
    end
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn, band: band} do
    assert_error_sent 404, fn ->
      get conn, band_song_path(conn, :show, band, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn, band: band} do
    conn = post conn, band_song_path(conn, :create, band.id), data: %{type: "songs", attributes: @valid_attrs}
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Song, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn, band: band} do
    conn = post conn, band_song_path(conn, :create, band), data: %{type: "songs", attributes: @invalid_attrs}
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource from band when data is valid", %{conn: conn, band: band} do
    song = Repo.insert! %Song{band_id: band.id}
    conn = put conn, band_song_path(conn, :update, band, song), data: %{type: "songs", attributes: @valid_attrs}
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Song, @valid_attrs)
  end
  test "updates and renders chosen resource when data is valid", %{conn: conn, band: band} do
    song = Repo.insert! %Song{band_id: band.id}
    conn = put conn, song_path(conn, :update, song), data: %{type: "songs", attributes: @valid_attrs}
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Song, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, band: band} do
    song = Repo.insert! %Song{band_id: band.id}
    conn = put conn, band_song_path(conn, :update, band, song), data: %{type: "songs", attributes: @invalid_attrs}
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource from band", %{conn: conn, band: band} do
    song = Repo.insert! %Song{band_id: band.id}
    conn = delete conn, band_song_path(conn, :delete, band, song)
    assert response(conn, 204)
    refute Repo.get(Song, song.id)
  end

  test "deletes chosen resource", %{conn: conn, band: band} do
    song = Repo.insert! %Song{band_id: band.id}
    conn = delete conn, song_path(conn, :delete, song)
    assert response(conn, 204)
    refute Repo.get(Song, song.id)
  end
end
