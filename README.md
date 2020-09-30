# Transponder

DRY up your Phoenix controllers.

## Features

- Turns controllers into declarative code.
- Works with any context function that returns a tagged tuple like `{:ok, ...}` or `{:error, ...}`
- Understands `Ecto.Changeset` errors and can render the error.
- Built in responders for JSON and HTML and ability to create custom ones.

**Disclaimer**: this is intended for simple apps or for when you're just starting out building an app. More complex apps will require more code in their controllers and should use standard Phoenix controllers and tests. This is just a starting point.

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
  use Transponder,
    responder: Transponder.Responders.JSON

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

  def render("index.json", %{response: products}) do
    %{products: Enum.map(&render("show.json", response: &1))}
  end

  def render("show.json", %{response: product}) do
    %{
      id: product.id,
      title: product.title,
      price: product.price,
    }
  end
end
```

To render HTML instead of JSON use `Responders.HTML`:

```elixir
defmodule MayAppWeb.Admin.ProductController do
  use MyAppWeb, :controller
  use Transponder,
    responder: Transponder.Responders.HTML

  # defaction ...
end
```

And then you'll need to create templates for the actions you use: `index.html.eex`, `show.html.eex`, etc..

You can also create a custom responder:

```elixir
defmodule MyResponder do
  @behaviour Transponder.Responder

  # pattern match and render how you like
  @impl true
  def respond(_action, conn, {:ok, bla}) do
    conn
    |> put_status(200)
    |> render("yay.html")
  end

  def respond(_action, conn, {:error, bla}) do
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
