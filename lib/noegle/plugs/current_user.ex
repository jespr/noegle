defmodule Noegle.Plug.CurrentUser do
  @moduledoc """
  This plugs makes `current_user` availabe in `conn.assigns.current_user` if the
  user has been set on the session
  """
  def init(opts), do: opts

  def call(conn, _opts) do
    current_user = Noegle.Session.current_user(conn)
		if current_user != nil do
			Plug.Conn.assign(conn, :current_user, current_user)
		else
			conn
		end
  end
end
