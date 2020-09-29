defmodule ResourceController.Responders.JSON do
  import Plug.Conn
  import Phoenix.Controller

  def respond(action, conn, fun) do
    case {action, fun.(conn)} do
      {_action, {:error, :not_found}} ->
        conn
        |> put_status(:not_found)
        |> json(%{message: "Not found"})

      {:index, {:ok, response}} ->
        conn
        |> put_status(200)
        |> render("index.json", response: response)

      {:create, {:ok, response}} ->
        conn
        |> put_status(201)
        |> render("show.json", response: response)

      {:show, {:ok, response}} ->
        conn
        |> put_status(200)
        |> render("show.json", response: response)

      {_action, _response} ->
        conn
        |> put_status(500)
        |> json(%{message: "Unknown error. Please contact support."})
    end
  end
end
