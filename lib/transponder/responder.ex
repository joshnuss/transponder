defmodule Transponder.Responder do
  @callback respond(atom, Plug.Conn.t(), term) :: Plug.Conn.t()
end
