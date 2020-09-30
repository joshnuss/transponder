defmodule Transponder.HTML do
  @behaviour Transponder.Formatter

  import Plug.Conn
  import Phoenix.Controller

  @impl true
  def format(_action, conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> render("404.html")
  end

  def format(:new, conn, {:ok, record}) do
    render(conn, "new.html", record: record)
  end

  def format(:create, conn, {:error, changeset = %Ecto.Changeset{}}) do
    conn
    |> put_status(:unprocessable_entity)
    |> render("new.html", record: changeset.data, changeset: changeset)
  end

  def format(:create, conn, {:ok, _record}) do
    conn
    |> put_flash(:info, "Created")
    |> redirect(to: "/")
  end

  def format(:edit, conn, {:ok, record}) do
    render(conn, "edit.html", record: record)
  end

  def format(:update, conn, {:error, changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> render("edit.html", record: changeset.data, changeset: changeset)
  end

  def format(:update, conn, {:ok, _record}) do
    conn
    |> put_flash(:info, "Updated")
    |> redirect(to: "/")
  end

  def format(:index, conn, records) do
    render(conn, "index.html", records: records)
  end

  def format(:show, conn, {:ok, record}) do
    render(conn, "show.html", record: record)
  end

  def format(:delete, conn, {:ok, _record}) do
    conn
    |> put_flash(:info, "Deleted")
    |> redirect(to: "/")
  end

  if Mix.env() != :dev do
    def format(_action, conn, _response) do
      conn
      |> put_status(500)
      |> render("500.html")
    end
  end
end
