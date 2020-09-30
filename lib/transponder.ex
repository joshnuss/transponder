defmodule Transponder do
  @moduledoc """
  Documentation for Transponder.
  """

  defmacro __using__(opts) do
    format = Keyword.fetch!(opts, :format)

    quote do
      import Transponder

      @formatter unquote(format)
    end
  end

  defmacro defaction(name, fun) do
    quote do
      def unquote(name)(conn, params) do
        data = %{conn: conn, params: params, assigns: conn.assigns}
        @formatter.format(unquote(name), conn, unquote(fun).(data))
      end
    end
  end
end
