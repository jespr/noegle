defmodule NoegleExampleApp.SessionController do
  use NoegleExampleApp.Web, :controller
  import Noegle.Session

  alias NoegleExampleApp.User

  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => %{"email" => email, "password" => password}}) do
    user = Repo.get_by!(User, email: email)
    if User.valid_password?(password, user.password_digest) do
      conn
      |> authenticate(user)
      |> put_flash(:notice, "Logged in!")
      |> redirect(to: "/")
    else
      conn
      |> put_flash(:error, "Couldn't log you in")
      |> render("new.html")
    end
  end
end