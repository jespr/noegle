defmodule NoegleExampleApp.User do
  use NoegleExampleApp.Web, :model
  use Noegle.Schema

  schema "users" do
    field :name, :string
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
    |> cast(params, [:name, :email, :password, :password_confirmation])
    |> validate_required([:name, :email])
    |> validate_confirmation(:password)
    |> hash_password()
  end
end
