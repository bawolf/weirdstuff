defmodule WeirdStuff.UserTest do
  use WeirdStuff.ModelCase

  alias WeirdStuff.User

  @valid_attrs %{password_digest: "some content", usemail: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end
