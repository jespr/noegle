defmodule NoegleExampleApp.SecretController do
  use NoegleExampleApp.Web, :controller

  def index(conn, _) do
    render(conn, "index.html")
  end

end
