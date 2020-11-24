defmodule Transponder.JSON do
  @behaviour Transponder.Formatter

  import Plug.Conn
  import Phoenix.Controller

  @impl true
  def format(_action, conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> json(%{message: "Not found"})
  end

  def format(_action, conn, {:error, changeset = %Ecto.Changeset{}}) do
    error_view = Application.get_env(:transponder, :error_view)

    conn
    |> put_status(:unprocessable_entity)
    |> put_view(error_view)
    |> render("error.json", changeset: changeset)
  end

  def format(:index, conn, {:ok, records}) do
    format(:index, conn, records)
  end

  def format(:index, conn, records) do
    render(conn, "index.json", records: records)
  end

  def format(:create, conn, {:ok, record}) do
    conn
    |> put_status(:created)
    |> render("show.json", record: record)
  end

  def format(_action, conn, {:ok, record}) do
    render(conn, "show.json", record: record)
  end

  if Mix.env() != :dev do
    def format(_action, conn, _record) do
      conn
      |> put_status(:internal_server_error)
      |> json(%{message: "Unknown error. Please contact support."})
    end
  end
end
