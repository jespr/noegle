defmodule Noegle.Trackable do
  import Ecto.Query
  require Logger

  @moduledoc """
  This module contains a function to track login meta data such as time of login and ip
  """

  @doc """
  Sets the `user_id` on the session

  Returns conn
  """
  def track_login(conn, user) do
    repo = Application.get_env(:noegle, :repo)
    user_module = Application.get_env(:noegle, :user)
    IO.inspect repo
    IO.inspect user_module
    ip = conn.peer |> elem(0) |> inspect

    changeset = user_module.changeset(user,
      %{
        sign_in_count: user.sign_in_count + 1,
        current_sign_in_at: Ecto.DateTime.utc,
        current_sign_in_ip: ip,
      })

    case repo.update changeset do
      {:ok, user} ->
        conn
      {:error, _changeset} ->
        Logger.error("Failed to update login details")
        conn
    end
  end
end
