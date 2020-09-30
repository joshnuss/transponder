defmodule Transponder.HTML do
  @behaviour Transponder.Responder

  import Plug.Conn
  import Phoenix.Controller

  @impl true
  def respond(_action, conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> render("404.html")
  end

  def respond(:new, conn, {:ok, record}) do
    render(conn, "new.html", record: record)
  end

  def respond(:create, conn, {:error, changeset = %Ecto.Changeset{}}) do
    conn
    |> put_status(:unprocessable_entity)
    |> render("new.html", record: changeset.data, changeset: changeset)
  end

  def respond(:create, conn, {:ok, _record}) do
    conn
    |> put_flash(:info, "Created")
    |> redirect(to: "/")
  end

  def respond(:edit, conn, {:ok, record}) do
    render(conn, "edit.html", record: record)
  end

  def respond(:update, conn, {:error, changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> render("edit.html", record: changeset.data, changeset: changeset)
  end

  def respond(:update, conn, {:ok, _record}) do
    conn
    |> put_flash(:info, "Updated")
    |> redirect(to: "/")
  end

  def respond(:index, conn, {:ok, records}) do
    render(conn, "index.html", records: records)
  end

  def respond(:show, conn, {:ok, record}) do
    render(conn, "show.html", record: record)
  end

  def respond(:delete, conn, {:ok, _record}) do
    conn
    |> put_flash(:info, "Deleted")
    |> redirect(to: "/")
  end

  if Mix.env() != :dev do
    def respond(_action, conn, _response) do
      conn
      |> put_status(500)
      |> render("500.html")
    end
  end
end
