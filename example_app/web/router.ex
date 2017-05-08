defmodule NoegleExampleApp.Router do
  use NoegleExampleApp.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Noegle.Plug.CurrentUser
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", NoegleExampleApp do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/users", UserController
    resources "/sessions", SessionController, only: [:new, :create]
  end

  # Other scopes may use custom stacks.
  # scope "/api", NoegleExampleApp do
  #   pipe_through :api
  # end
end