defmodule Noegle.SessionTest do
  use Noegle.ConnCase

  alias Noegle.Session

  defmodule MockRepo do
    def get(MockUser, id) do
      if id == 42 do
        %{}
      else
        nil
      end
    end
  end

  test "authenticate sets user_id on the session" do
    conn = Session.authenticate(conn(), %{id: 42})
    
    assert Plug.Conn.get_session(conn, :user_id) == 42
  end

  test "current_user fetches the current user if user_id is set on session" do
    Mix.Config.persist([noegle: %{repo: MockRepo, user: MockUser}])

    conn = Plug.Conn.put_session(conn(), :user_id, 42)

    assert Session.current_user(conn)
  end

  test "current_user returns nil if no user_id is set on session" do
    Mix.Config.persist([noegle: %{repo: MockRepo, user: MockUser}])

    assert Plug.Conn.get_session(conn(), :user_id) == nil
    refute Session.current_user(conn())
  end
end
