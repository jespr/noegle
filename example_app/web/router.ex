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

  pipeline :protected do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Noegle.Plug.CurrentUser
    plug Noegle.Plug.RequireAuth
  end


  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", NoegleExampleApp do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/users", UserController
    resources "/sessions", SessionController, only: [:new, :create, :delete]
  end

  scope "/", NoegleExampleApp do
    pipe_through :protected

    resources "/secret", SecretController, only: [:index]
  end

  # Other scopes may use custom stacks.
  # scope "/api", NoegleExampleApp do
  #   pipe_through :api
  # end
end
