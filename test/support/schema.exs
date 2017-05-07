defmodule TestNoegle.User do
  use Ecto.Schema
  use Noegle.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :password_digest, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
  end

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, [:email, :password, :password_confirmation])
    |> validate_required([:email])
    |> unique_constraint(:email)
    |> validate_confirmation(:password)
    |> hash_password()
  end
end
