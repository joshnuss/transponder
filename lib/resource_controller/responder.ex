defmodule ResourceController.Responder do
  @callback respond(atom, Plug.Conn.t(), fun) :: Plug.Conn.t()
end
