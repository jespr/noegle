defmodule Noegle.Session do
  alias Plug.Conn
  @session_key :user_id

  @moduledoc """
  This module contains convenience methods for setting and retrieving things from the session

  ## Examples:

  * `authenticate/2` - sets the `user_id` on the session
  * `current_user/1` - returns the currently logged in user
  * `logged_in/1` - returns true if the user is logged in
  """

  @doc """
  Sets the `user_id` on the session

  Returns conn
  """
  def authenticate(conn, user) do
    Conn.assign conn, :current_user, user
    Conn.put_session(conn, @session_key, user.id)
  end

  @doc """
  Removes the `user_id` on the session and thus logs out the user

  Returns conn
  """
  def logout(conn) do
    Plug.Conn.delete_session(conn, @session_key)
  end

  @doc """
  This method returns the `current_user` if `user_id` is set on the session.
  It uses the `:repo` and `:user` as set in the `:noegle` config in the applications configuration.

  If `user_id` doesn't exist or a user can't be found it returns nil
  """
  def current_user(conn) do
    user_id = Plug.Conn.get_session(conn, @session_key)
    repo = Application.get_env(:noegle, :repo)
    user_module = Application.get_env(:noegle, :user)

    if user_id != nil do
      repo.get(user_module, user_id)
    end
  end

  @doc """
  This method returns true if the user is logged in.

  This requires that the plug Noegle.Plug.CurrentUser has been run

  Returns boolean
  """
  def logged_in?(conn) do
    conn.assigns[:current_user] != nil
  end
end
