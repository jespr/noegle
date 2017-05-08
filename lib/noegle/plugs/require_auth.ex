defmodule Noegle.Plug.RequireAuth do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    if Noegle.Session.logged_in?(conn) do
      conn
    else
      conn
      |> Phoenix.Controller.redirect(to: Application.get_env(:noegle, :login_path) || "/sessions/new")
      |> halt
    end
  end
end
