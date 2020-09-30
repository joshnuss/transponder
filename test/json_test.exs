defmodule JSONTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias Transponder.JSON

  defmodule TestView do
    use Phoenix.View, root: "test/support"

    def render("index.json", %{records: records}) do
      records
    end

    def render("show.json", %{record: record}) do
      record
    end
  end

  test "formats to {:error, :not_found} with 404" do
    conn = build_conn(:get, "/any_action")
    conn = JSON.format(:any_action, conn, {:error, :not_found})

    assert conn.status == 404
    assert conn.resp_body == ~s|{"message":"Not found"}|
  end

  test "formats to {:error, changeset} with 422" do
    conn = build_conn(:get, "/any_action")
    conn = JSON.format(:any_action, conn, {:error, FakeSchema.changeset()})

    assert conn.status == 422
    assert conn.resp_body == ~s|{"name":["can't be blank"]}|
  end

  test "formats to create {:ok, reponse} with 201" do
    conn = build_conn(:post, "/any_action")
    conn = JSON.format(:create, conn, {:ok, %{id: 123}})

    assert conn.status == 201
    assert conn.resp_body == ~s|{"id":123}|
  end

  test "formats to update {:ok, reponse} with 200" do
    conn = build_conn(:patch, "/any_action")
    conn = JSON.format(:update, conn, {:ok, %{id: 123}})

    assert conn.status == 200
    assert conn.resp_body == ~s|{"id":123}|
  end

  test "formats to delete {:ok, reponse} with 200" do
    conn = build_conn(:delete, "/any_action")
    conn = JSON.format(:delete, conn, {:ok, %{id: 123}})

    assert conn.status == 200
    assert conn.resp_body == ~s|{"id":123}|
  end

  test "formats to show {:ok, reponse} with 200" do
    conn = build_conn(:post, "/any_action")
    conn = JSON.format(:show, conn, {:ok, %{id: 123}})

    assert conn.status == 200
    assert conn.resp_body == ~s|{"id":123}|
  end

  test "formats to index {:ok, reponse} with 200" do
    conn = build_conn(:post, "/any_action")
    conn = JSON.format(:show, conn, {:ok, [%{id: 123}]})

    assert conn.status == 200
    assert conn.resp_body == ~s|[{"id":123}]|
  end

  test "formats to unknown response with 500" do
    conn = build_conn(:get, "/any_action")
    conn = JSON.format(:any_action, conn, :rubbish)

    assert conn.status == 500
    assert conn.resp_body == ~s|{"message":"Unknown error. Please contact support."}|
  end

  defp build_conn(method, action) do
    conn(method, action) |> Phoenix.Controller.put_view(TestView)
  end
end
