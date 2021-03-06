defmodule NogleTest.Schema do
  use ExUnit.Case
  alias TestNoegle.User

  setup do
    :ok
  end

  @email "user@test.com"
  @password "123456"

  test "valid if passwords matches" do
    changeset = User.changeset(%User{}, %{email: @email, password: @password, password_confirmation: @password})
    assert changeset.valid?
  end

  test "invalid if passwords doesn't matches" do
    changeset = User.changeset(%User{}, %{email: @email, password: @password, password_confirmation: "somethingelse"})
    refute changeset.valid?
  end

  test "the password_digest value gets set to a hash if password is given" do
    changeset = User.changeset(%User{}, %{email: @email, password: @password, password_confirmation: @password})
    assert Comeonin.Bcrypt.checkpw(@password, Ecto.Changeset.get_change(changeset, :password_digest))
  end
  
  test "the password_digest value does not get set if no password is given" do
    changeset = User.changeset(%User{}, %{email: @email, password: nil, password_confirmation: nil})
    refute Ecto.Changeset.get_change(changeset, :password_digest)
  end

  describe "valid_password?" do
    test "returns true if the clear text password matches the given hashed password" do
      changeset = User.changeset(%User{}, %{email: @email, password: @password, password_confirmation: @password})
      assert User.valid_password?(@password, Ecto.Changeset.get_change(changeset, :password_digest))
    end

    test "returns false if the clear text password doesn't match the given hashed password" do
      changeset = User.changeset(%User{}, %{email: @email, password: @password, password_confirmation: @password})
      refute User.valid_password?("somethingnotpassword", Ecto.Changeset.get_change(changeset, :password_digest))
    end
  end
end
