defmodule ResourceController do
  @moduledoc """
  Documentation for ResourceController.
  """

  defmacro __using__(opts) do
    responder = Keyword.fetch!(opts, :responder)

    quote do
      import ResourceController

      @responder unquote(responder)
    end
  end

  defmacro defaction(name, fun) do
    quote do
      def unquote(name)(conn, params) do
        @responder.respond(unquote(name), conn, unquote(fun))
      end
    end
  end
end
