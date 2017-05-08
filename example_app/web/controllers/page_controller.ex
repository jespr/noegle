defmodule NoegleExampleApp.PageController do
  use NoegleExampleApp.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
