defmodule Transponder.JSON do
  @behaviour Transponder.Responder

  import Plug.Conn
  import Phoenix.Controller

  @impl true
  def respond(_action, conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> json(%{message: "Not found"})
  end

  def respond(_action, conn, {:error, changeset = %Ecto.Changeset{}}) do
    conn
    |> put_status(:unprocessable_entity)
    |> render("errors.json", changeset: changeset)
  end

  def respond(:index, conn, {:ok, response}) do
    render(conn, "index.json", response: response)
  end

  def respond(:create, conn, {:ok, response}) do
    conn
    |> put_status(201)
    |> render("show.json", response: response)
  end

  def respond(:show, conn, {:ok, response}) do
    render(conn, "show.json", response: response)
  end

  if Mix.env() != :dev do
    def respond(_action, conn, _record) do
      conn
      |> put_status(500)
      |> json(%{message: "Unknown error. Please contact support."})
    end
  end
end
