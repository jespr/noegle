defmodule Noegle.Session do
  alias Plug.Conn
  @session_key :user_id
  @return_to_key :return_to

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

  def return_to_url(conn) do
    return_to_url = case Conn.get_session(conn, @return_to_key) do
      nil -> "/"
      value -> value
    end

    Conn.put_session(conn, @return_to_key, nil)

    return_to_url
  end

  @doc """
  Removes the `user_id` on the session and thus logs out the user

  Returns conn
  """
  def logout(conn) do
    conn
    |> Plug.Conn.delete_session(@session_key)
    |> Plug.Conn.delete_session(@return_to_key)
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

  def store_return_to(conn) do
    return_to = Path.join(["/" | conn.path_info])
    Conn.put_session(conn, @return_to_key, return_to)
  end
end
