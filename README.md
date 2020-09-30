# Transponder

DSL for declarative Phoenix controllers.

## Features

- Turns controllers into declarative code.
- Works with all context functions that return a tagged tuple like `{:ok, ...}` or `{:error, ...}`
- Supports rendering `Ecto.Changeset` errors.
- Built-in formatters for JSON and HTML with ability to add custom ones.

**Disclaimer**: This is intended for simple apps or when starting to build an application. More complex apps may require more complexity in their controllers, and then a standard Phoenix controller with tests would work better. This is just a starting point.

## Installation

Add `transponder` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:transponder, "~> 0.1.0"}
  ]
end
```

Add `use Transponder` to your controllers, and define actions with `defaction`:

```elixir
defmodule MyAppWeb.Admin.ProductsController do
  use MyAppWeb, :controller
  use Transponder, format: Transponder.JSON

  defaction :index,  &Catalog.list_products(&1.params)
  defaction :show,   &Catalog.get_product(&1.params)
  defaction :create, &Catalog.create_product(&1.params["product"])
  defaction :update, &Catalog.update_product(&1.params["id"], &1.params["product"])
  defaction :delete, &Catalog.delete_product(&1.params["id"])
end
```

Then define a `show.json.eex` and `index.json.eex`. Or you can use a `Phoenix.View`:

```elixir
defmodule MyAppWeb.Admin.ProductsView do
  use MyAppWeb, :view

  def render("index.json", %{records: products}) do
    %{products: Enum.map(&render("show.json", response: &1))}
  end

  def render("show.json", %{record: product}) do
    %{
      id: product.id,
      title: product.title,
      price: product.price,
    }
  end
end
```

To handle errors, configure the error view in `config/config.exs`:

```elixir
config :transponder, :error_view, MyAppWeb.ErrorView
```

To render HTML instead of JSON use `Transponder.HTML`:

```elixir
defmodule MayAppWeb.Admin.ProductController do
  use MyAppWeb, :controller
  use Transponder, format: Transponder.HTML

  # defaction ...
end
```

And then you'll need to create templates for the actions you use: `index.html.eex`, `show.html.eex`, etc..

You can also create a custom formatter:

```elixir
defmodule MyFormat do
  @behaviour Transponder.Formatter

  # pattern match and render how you like
  @impl true
  def format(_action, conn, {:ok, bla}) do
    conn
    |> put_status(200)
    |> render("yay.html")
  end

  def format(_action, conn, {:error, bla}) do
    conn
    |> put_status(401)
    |> render("oops.html")
  end
end
```

## Documentation:

[https://hexdocs.pm/transponder](https://hexdocs.pm/transponder).

## License

MIT
