defmodule Rarwe.SongController do
  use Rarwe.Web, :controller

  alias Rarwe.{Band, Song}

  def index(conn, %{"band_id" => band_id}) do
    songs = Repo.all(from(s in Song, where: s.band_id == ^band_id))
    render(conn, "index.json", data: songs)
  end
  def index(conn, _params) do
    songs = Repo.all(Song)
    render(conn, "index.json", data: songs)
  end

  def create(conn, %{"band_id" => band_id, "data" => %{"type" => "songs", "attributes" => song_params}}) do
    band = Repo.get!(Band, band_id)
    changeset = Song.changeset(build_assoc(band, :songs), song_params)

    case Repo.insert(changeset) do
      {:ok, song} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", band_song_path(conn, :show, band_id, song))
        |> render("show.json", data: song)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Rarwe.ChangesetView, "error.json", changeset: changeset)
    end
  end
  def create(conn, %{"data" => %{"type" => "songs", "attributes" => song_params, "relationships" => %{"band" => %{"data" => %{"id" => band_id}}}}}) do
    band = Repo.get!(Band, band_id)
    changeset = Song.changeset(build_assoc(band, :songs), song_params)

    case Repo.insert(changeset) do
      {:ok, song} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", band_song_path(conn, :show, band_id, song))
        |> render("show.json", data: song)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Rarwe.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"band_id" => band_id, "id" => id}) do
    song = Repo.get!(from(s in Song, where: s.band_id == ^band_id), id)
    render(conn, "show.json", data: song)
  end
  def show(conn, %{"id" => id}) do
    song = Repo.get!(Song, id)
    render(conn, "show.json", data: song)
  end

  def update(conn, %{"band_id" => band_id, "id" => id, "data" => %{"type" => "songs", "attributes" => song_params}}) do
    song = Repo.get_by!(Song, id: id, band_id: band_id)
    changeset = Song.changeset(song, song_params)

    case Repo.update(changeset) do
      {:ok, song} ->
        render(conn, "show.json", data: song)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Rarwe.ChangesetView, "error.json", changeset: changeset)
    end
  end
  def update(conn, %{"id" => id, "data" => %{"type" => "songs", "attributes" => song_params, "relationships" => %{"band" => %{"data" => %{"id" => band_id}}}}}) do
    song = Repo.get_by!(Song, id: id, band_id: band_id)
    changeset = Song.changeset(song, song_params)

    case Repo.update(changeset) do
      {:ok, song} ->
        render(conn, "show.json", data: song)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Rarwe.ChangesetView, "error.json", changeset: changeset)
    end
  end
  def update(conn, %{"id" => id, "data" => %{"type" => "songs", "attributes" => song_params}}) do
    song = Repo.get!(Song, id)
    changeset = Song.changeset(song, song_params)

    case Repo.update(changeset) do
      {:ok, song} ->
        render(conn, "show.json", data: song)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Rarwe.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    song = Repo.get!(Song, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(song)

    send_resp(conn, :no_content, "")
  end
end
