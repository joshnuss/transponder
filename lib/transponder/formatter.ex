defmodule Transponder.Formatter do
  @callback format(atom, Plug.Conn.t(), term) :: Plug.Conn.t()
end
