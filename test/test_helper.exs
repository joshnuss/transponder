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

defmodule TestErrorView do
  use Phoenix.View, root: "test/support"

  def render("error.json", %{changeset: changeset}) do
    Ecto.Changeset.traverse_errors(changeset, &translate_error/1)
  end

  def render("error.json", %{changesets: changesets}) do
    changesets
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {changeset, index}, map ->
      Map.put(map, index, translate_errors(changeset))
    end)
  end

  defp translate_error({message, values}) do
    Enum.reduce(values, message, fn {k, v}, acc ->
      String.replace(acc, "%{#{k}}", to_string(v))
    end)
  end

  def translate_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, &translate_error/1)
  end
end

ExUnit.start()
