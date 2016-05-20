defmodule Rarwe.Repo.Migrations.CreateBand do
  use Ecto.Migration

  def change do
    create table(:bands) do
      add :name, :string
      add :description, :text

      timestamps
    end

  end
end
