# ResourceController

DRY up your Phoenix controllers.

## Features

- Turns controllers into declarative code.
- Works with any context function that returns a tagged tuple like `{:ok, ...}` or `{:error, ...}`
- Understands `Ecto.Changeset` errors and can render the error.
- Built in responders for JSON and HTML and ability to create custom ones.

*DISCLAIMER*: this is intended for simple apps or for when your just starting building an app. More complex apps will require more code in their controllers and should use standard Phoenix controllers and tests.

## Installation

Add `resource_controller` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:resource_controller, "~> 0.1.0"}
  ]
end
```

Add `ResourceController` to your controllers:

```elixir
defmodule MyAppWeb.Admin.ProductsController do
  use MyAppWeb, :controller
  use ResourceController,
    responder: ResourceController.Reponders.JSON

  defaction :index, &Catalog.list_products(&.params)
  defaction :show, &Catalog.get_product(&.params)
  defaction :create, &Catalog.create_product(&.params["product"])
  defaction :update, &Catalog.update_product(&.params["id"], &.params["product"])
  defaction :delete, &Catalog.delete_product(&.params["id"])
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
  use ResourceController,
    responder: ResourceController.Reponders.HTML

  # defaction ...
end
```

And then you'll need to create templates for the actions you use: `index.html.eex`, `show.html.eex`, etc..

You can also create a custom responder:

```elixir
defmodule MyResponder do
  @behaviour ResourceController.Responder

  @impl true
  def respond(action, conn, fun) do
    # pattern match and render how you like
    case fun.(conn) do
      {:ok, bla} ->
        conn
        |> put_status(200)
        |> render("yay.html")
    end
  end
end
```

## Documentation:

[https://hexdocs.pm/resource_controller](https://hexdocs.pm/resource_controller).

## License

MIT
