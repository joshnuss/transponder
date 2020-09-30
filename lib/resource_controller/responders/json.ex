defmodule ResourceController.Responders.JSON do
  @behaviour ResourceController.Responder

  import Plug.Conn
  import Phoenix.Controller

  @impl true
  def respond(action, conn, response) do
    case {action, response} do
      {_action, {:error, :not_found}} ->
        conn
        |> put_status(:not_found)
        |> json(%{message: "Not found"})

      {_action, {:error, changeset = %Ecto.Changeset{}}} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("errors.json", changeset: changeset)

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
