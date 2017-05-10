defmodule BaseApp.Noegle.SessionController do
  use BaseApp.Web, :controller
  alias BaseApp.User

  def new(conn, _) do
    changeset = User.changeset(%User{})
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"session" => %{"email" => email, "password" => password}}) do
    user = Repo.get_by(User, email: email)
    if user != nil && User.valid_password?(password, user.password_digest) do
      conn
      |> Noegle.Session.authenticate(user)
      |> put_flash(:notice, "Logged in!")
      |> redirect(to: "/")
    else
      conn
      |> put_flash(:error, "Couldn't log you in")
      |> render("new.html", [{:email, email}])
    end
  end

  def delete(conn, _) do
    conn
    |> Noegle.Session.logout()
    |> put_flash(:notice, "Logged out!")
    |> redirect(to: "/")
  end
end
