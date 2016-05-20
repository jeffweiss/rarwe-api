defmodule Rarwe.BandControllerTest do
  use Rarwe.ConnCase

  alias Rarwe.Band
  @valid_attrs %{description: "some content", name: "some content"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, band_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    band = Repo.insert! %Band{}
    conn = get conn, band_path(conn, :show, band)
    assert json_response(conn, 200)["data"] == %{
      "type" => "band",
      "id" => to_string(band.id),
      "attributes" => %{
        "name" => band.name,
        "description" => band.description
      },
      "relationships" => %{"songs" => %{"links" => %{"related" => band_song_url(Rarwe.Endpoint, :index, band)}}}}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, band_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, band_path(conn, :create), data: %{type: "band", attributes: @valid_attrs}
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Band, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, band_path(conn, :create), data: %{type: "band", attributes: @invalid_attrs}
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    band = Repo.insert! %Band{}
    conn = put conn, band_path(conn, :update, band), data: %{type: "band", attributes: @valid_attrs}
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Band, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    band = Repo.insert! %Band{}
    conn = put conn, band_path(conn, :update, band), data: %{type: "band", attributes: @invalid_attrs}
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    band = Repo.insert! %Band{}
    conn = delete conn, band_path(conn, :delete, band)
    assert response(conn, 204)
    refute Repo.get(Band, band.id)
  end
end
