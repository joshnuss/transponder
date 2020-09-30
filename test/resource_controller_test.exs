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

    defaction :index, fn _conn -> 123 end
    defaction :create, fn _conn -> 456 end
    defaction :special, fn _conn -> 123 end
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
end
