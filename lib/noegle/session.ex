defmodule Noegle.Session do
  import Plug.Conn

  @moduledoc """
  This module contains convenience methods for setting and retrieving things from the session

  ## Examples:
  
  * `authenticate/2` - given a `conn` and a `user` it will set `user_id` on the session corresponding to `user.id`
  * `current_user/1` - given a `conn` it will fetch the user from the database if a `user_id` exists on the session
  """

  @doc """
  Sets the `user_id` on the session
  
  Returns conn
  """
  def authenticate(conn, user) do
    Plug.Conn.put_session(conn, :user_id, user.id)
  end

  @doc """
  This method returns the `current_user` if `user_id` is set on the session.
  It uses the `:repo` and `:user` as set in the `:noegle` config in the applications configuration.

  If `user_id` doesn't exist or a user can't be found it returns nil
  """
  def current_user(conn) do
    user_id = Plug.Conn.get_session(conn, :user_id)
    repo = Application.get_env(:noegle, :repo)
    user_module = Application.get_env(:noegle, :user)

    if user_id != nil do
      repo.get(user_module, user_id)
    end
  end
end
