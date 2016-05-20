defmodule Rarwe.BandController do
  use Rarwe.Web, :controller

  alias Rarwe.Band

  def index(conn, _params) do
    bands = Repo.all(Band)
    render(conn, "index.json", data: bands)
  end

  def create(conn, %{"data" => %{"type" => "band", "attributes" => band_params}}) do
    changeset = Band.changeset(%Band{}, band_params)

    case Repo.insert(changeset) do
      {:ok, band} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", band_path(conn, :show, band))
        |> render("show.json", data: band)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Rarwe.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    band = Repo.get!(Band, id)
    render(conn, "show.json", data: band)
  end

  def update(conn, %{"id" => id, "data" => %{"type" => "band", "attributes" => band_params}}) do
    band = Repo.get!(Band, id)
    changeset = Band.changeset(band, band_params)

    case Repo.update(changeset) do
      {:ok, band} ->
        render(conn, "show.json", data: band)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Rarwe.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    band = Repo.get!(Band, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(band)

    send_resp(conn, :no_content, "")
  end
end
