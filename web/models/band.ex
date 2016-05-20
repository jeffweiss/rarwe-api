defmodule Rarwe.Band do
  use Rarwe.Web, :model

  schema "bands" do
    field :name, :string
    field :description, :string
    has_many :songs, Rarwe.Song

    timestamps
  end

  @required_fields ~w(name description)
  @optional_fields ~w()

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
