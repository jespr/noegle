# Noegle

Nøgle (key in Danish) provides some basic functionality needed to add password
authentication to your Elixir application (aimed at Phoenix).

We present some convenience methods that'll make it easier for you to add
authentication to your Elixir Plug based application.

## Configuration

You can insert the default configuration into `config/config.exs` by using our
config generator by running `mix noegle.generate.config` which will insert the
following:

```elixir
config :noegle,
  repo: NoegleExampleApp.Repo,
  user: NoegleExampleApp.User,
  # The path a user will be redirected to if they access
  # a page that requires login
  login_path: "/sessions/new",
```

## Boilerplate

We provide some basic boilerplate which consists of controllers, views and templates.
These can be generated and used as a foundation for your app.

Run the following command to generate these:
`mix noegle.generate.boilerplate`

## Scenarios

### Create user

You add `password` and `password_confirmation` as virtual fields to your model
as well as `password_digest` to your database. You can then use
`hash_password()` in your `changeset` to ensure the password is persisted in a
hashed format

```elixir
defmodule NoegleExampleApp.User do
  use NoegleExampleApp.Web, :model
  use Noegle.Schema

  schema "users" do
    field :email, :string
    field :password_digest, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:email, :password, :password_confirmation])
    |> validate_required([:name, :email])
    |> validate_confirmation(:password)
    |> hash_password()
  end
end
```

### Login

In your `SessionsController` or `LoginController` or what the name might be, you
can add a `create` function that looks like this:

```elixir
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
```

The `authenticate(user)` call correctly sets the logged in user in the session.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `noegle` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:noegle, "~> 0.1.0"}]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/noegle](https://hexdocs.pm/noegle).

