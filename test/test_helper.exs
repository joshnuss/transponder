defmodule FakeSchema do
  use Ecto.Schema
  import Ecto.Changeset

  schema "baz" do
    field(:name, :string)
  end

  def changeset(params \\ %{}) do
    %__MODULE__{id: 123}
    |> cast(params, [])
    |> validate_required(:name)
  end
end

ExUnit.start()
