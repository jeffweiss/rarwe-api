defmodule Rarwe.Song do
  use Rarwe.Web, :model

  schema "songs" do
    field :title, :string
    field :rating, :integer, default: 0
    belongs_to :band, Rarwe.Band

    timestamps
  end

  @required_fields ~w(title band_id)
  @optional_fields ~w(rating)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
