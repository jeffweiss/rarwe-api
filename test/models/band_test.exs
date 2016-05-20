defmodule Rarwe.BandTest do
  use Rarwe.ModelCase

  alias Rarwe.Band

  @valid_attrs %{description: "some content", name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Band.changeset(%Band{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Band.changeset(%Band{}, @invalid_attrs)
    refute changeset.valid?
  end
end
