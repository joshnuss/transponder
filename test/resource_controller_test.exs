defmodule ResourceControllerTest do
  use ExUnit.Case, async: true
  use Plug.Test
  doctest ResourceController

  defmodule TestResponder do
    import Plug.Conn

    @behaviour ResourceController.Responder

    @impl true
    def respond(:special, conn, _n) do
      resp(conn, 200, "special-case")
    end

    def respond(action, conn, n) do
      response = "#{action}:#{n}"
      resp(conn, 200, response)
    end
  end

  defmodule FakeController do
    use ResourceController, responder: TestResponder

    defaction(:index, fn _data -> 123 end)
    defaction(:create, fn _data -> 456 end)
    defaction(:special, fn _data -> 123 end)
    defaction(:with_assigns, fn data -> data.assigns.magic_number end)
    defaction(:with_param, fn data -> data.params["page"] end)
  end

  test "renders response" do
    conn = conn(:get, "/foo")

    conn = FakeController.index(conn, %{})
    assert conn.status == 200
    assert conn.resp_body == "index:123"

    conn = FakeController.create(conn, %{})
    assert conn.status == 200
    assert conn.resp_body == "create:456"

    conn = FakeController.special(conn, %{})
    assert conn.status == 200
    assert conn.resp_body == "special-case"
  end

  test "provides assigns" do
    conn = conn(:get, "/foo") |> assign(:magic_number, 41)

    conn = FakeController.with_assigns(conn, %{})
    assert conn.status == 200
    assert conn.resp_body == "with_assigns:41"
  end

  test "provides params" do
    conn = conn(:get, "/foo", %{page: 99})

    conn = FakeController.with_param(conn, %{})
    assert conn.status == 200
    assert conn.resp_body == "with_param:99"
  end
end
