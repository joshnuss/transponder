defmodule ResourceController.Responder do
  @callback respond(atom, Plug.Conn.t(), term) :: Plug.Conn.t()
end
