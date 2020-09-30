defmodule HTMLTest do
  use ExUnit.Case, async: true
  use Plug.Test

  import Phoenix.ConnTest

  alias Transponder.HTML

  defmodule TestView do
    use Phoenix.View, root: "test/support/html_test"

    def render("404.html", _assigns) do
      "Page not found"
    end

    def render("500.html", _assigns) do
      "Server internal error"
    end
  end

  test "responds to {:error, :not_found} with 404" do
    conn = build_conn_with_view(:get, "/any_action")
    conn = HTML.respond(:any_action, conn, {:error, :not_found})

    assert conn.status == 404
    assert conn.resp_body == "Page not found"
  end

  test "responds to new {:ok, response} with 200" do
    conn = build_conn_with_view(:get, "/new")
    conn = HTML.respond(:new, conn, {:ok, %{id: 123}})

    assert conn.status == 200
    assert conn.resp_body == "new rendered with id 123 and 0 errors\n"
  end

  test "responds to create {:error, changeset} with 422" do
    conn = build_conn_with_view(:post, "/create")
    conn = HTML.respond(:create, conn, {:error, FakeSchema.changeset()})

    assert conn.status == 422
    assert conn.resp_body == "new rendered with id 123 and 1 errors\n"
  end

  test "responds to create {:ok, response} with redirect" do
    conn = build_conn_with_view(:post, "/any_action")
    conn = HTML.respond(:create, conn, {:ok, %{id: 123}})

    assert redirected_to(conn) == "/"
    assert get_flash(conn, :info) == "Created"
  end

  test "responds to edit {:ok, response} with 200" do
    conn = build_conn_with_view(:post, "/edit")
    conn = HTML.respond(:edit, conn, {:ok, %{id: 123}})

    assert conn.status == 200
    assert conn.resp_body == "edit rendered with id 123 and 0 errors\n"
  end

  test "responds to update {:error, changeset} with 422" do
    conn = build_conn_with_view(:patch, "/update")
    conn = HTML.respond(:update, conn, {:error, FakeSchema.changeset()})

    assert conn.status == 422
    assert conn.resp_body == "edit rendered with id 123 and 1 errors\n"
  end

  test "responds to update {:ok, response} with redirect" do
    conn = build_conn_with_view(:patch, "/update")
    conn = HTML.respond(:update, conn, {:ok, %{id: 123}})

    assert redirected_to(conn) == "/"
    assert get_flash(conn, :info) == "Updated"
  end

  test "responds to index {:ok, response} with 200" do
    conn = build_conn_with_view(:get, "/")
    conn = HTML.respond(:index, conn, {:ok, [%{id: 123}]})

    assert conn.status == 200
    assert conn.resp_body == "index rendered 1\n"
  end

  test "responds to show {:ok, response} with 200" do
    conn = build_conn_with_view(:post, "/123")
    conn = HTML.respond(:show, conn, {:ok, %{id: 123}})

    assert conn.status == 200
    assert conn.resp_body == "show rendered 123\n"
  end

  test "responds to delete {:ok, response} with redirect" do
    conn = build_conn_with_view(:delete, "/123")
    conn = HTML.respond(:delete, conn, {:ok, %{id: 123}})

    assert redirected_to(conn) == "/"
    assert get_flash(conn, :info) == "Deleted"
  end

  test "responds to unknown response with 500" do
    conn = build_conn_with_view(:get, "/any_action")
    conn = HTML.respond(:any_action, conn, :rubbish)

    assert conn.status == 500
    assert conn.resp_body == "Server internal error"
  end

  @session Plug.Session.init(
    store: :cookie,
    key: "_app",
    encryption_salt: "yadayada",
    signing_salt: "yadayada"
  )

  defp with_session(conn) do
    conn
    |> Map.put(:secret_key_base, String.duplicate("abcdefgh", 8))
    |> Plug.Session.call(@session)
    |> Plug.Conn.fetch_session()
  end

  defp build_conn_with_view(method, action) do
    build_conn(method, action) |> Phoenix.Controller.put_view(TestView) |> with_session() |> fetch_flash()
  end
end
