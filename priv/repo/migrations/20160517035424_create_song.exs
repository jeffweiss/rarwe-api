defmodule Rarwe.Repo.Migrations.CreateSong do
  use Ecto.Migration

  def change do
    create table(:songs) do
      add :title, :string
      add :rating, :integer
      add :band_id, references(:bands, on_delete: :nothing)

      timestamps
    end
    create index(:songs, [:band_id])

  end
end
