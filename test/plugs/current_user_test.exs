defmodule Noegle.CurrentUserTest do
  use Noegle.ConnCase

  defmodule MockRepo do
    def get(MockUser, id) do
      if id == 42 do
        %{}
      else
        nil
      end
    end
  end

  test "current_user exists in conn.assigns if session contains user_id" do
    Mix.Config.persist([noegle: %{repo: MockRepo, user: MockUser}])

    conn = Plug.Conn.put_session(conn(), :user_id, 42)
      |> Noegle.Plug.CurrentUser.call(%{})
    assert conn.assigns.current_user
  end

  test "current_user isn't in conn.assigns when session doesn't contain user_id" do
    Mix.Config.persist([noegle: %{repo: MockRepo, user: MockUser}])

    conn = Noegle.Plug.CurrentUser.call(conn(), %{})
    refute Map.has_key?(conn.assigns, :current_user)
  end
end
