defmodule Noegle.Schema do
  @moduledoc """
  Add authentication support to your User schema module.

  Example:

  ```elixir
    defmodule MyApp.User do
      use MyApp.Web, :model
      use Noegle.Schema
  ```

  The following functions are available:

  * `hash_password/1` - hashes a password string using `Comeonin.Bcrypt.hashpwsalt`
  * `valid_password?/2` - checks that a clear text `password` matches the `hashed_password`

  ## Examples

  The following is a full example of what is required to use Noegle for your authentication

  ```elixir
  defmodule MyApp.Noegle do
    use MyApp.Web, :model
    use Noegle.Schema

    schema "users" do
      field :name, :string
      field :email, :string

      # These are the fields required for Noegle to work
      field :password_digest, :string
      field :password, :string, virtual: true
      field :password_confirmation, :string, virtual: true

      timestamps
    end

    @required_fields ~w(name email)
    @optional_fields ~w(password password_confirmation)

    def changeset(model, params \\ %{}) do
      model
      |> cast(params, @required_fields, @optional_fields)
      |> unique_constraint(:email)
      |> validate_confirmation(:password)
      |> hash_password() # Function that comes from Noegle which hashes the password
    end
    ```
  """

  defmacro __using__(_opts \\ []) do
    quote do
      import unquote(__MODULE__)
      import Ecto.Changeset
      import Comeonin.Bcrypt, only: [hashpwsalt: 1]

      @doc """
      Hashes password in a changeset using `Comeonin.Bcrypt.hashpwsalt/1`

      Returns the changeset
      """
      def hash_password(changeset) do
        if password = get_change(changeset, :password) do
          changeset
          |> put_change(:password_digest, hashpwsalt(password))
        else
          changeset
        end
      end

      @doc """
      Takes a clear text `password` and matches it against `hashed_password`

      Returns true/false
      """
      def valid_password?(password, hashed_password) do
        try do
          Comeonin.Bcrypt.checkpw(password, hashed_password)
        rescue
          _ -> false
        end
      end
    end
  end
end
