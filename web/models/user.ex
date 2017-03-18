defmodule WeirdStuff.User do
  use WeirdStuff.Web, :model
  import Comeonin.Bcrypt, only: [hashpwsalt: 1]
  alias WeirdStuff.{ Message, Device }

  @primary_key {:id, :binary_id, autogenerate: true}
  @derive {Phoenix.Param, key: :id}

  schema "users" do
    field :email, :string
    field :password_digest, :string

    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true 
    has_many :sent_messages, Message, foreign_key: :sender_id
    has_many :received_messages, Message, foreign_key: :receiver_id
    has_many :devices, Device, foreign_key: :owner_id

    timestamps()
  end

  @permitted_fields ~w(email password password_confirmation)

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @permitted_fields)
    |> validate_required([:email, :password, :password_confirmation])
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email, message: "has already been taken")
    |> passwords_match
    |> lowercase_email
    |> hash_password
  end

  defp hash_password(changeset) do
    if password = get_change(changeset, :password) do
      changeset
      |> put_change(:password_digest, hashpwsalt(password))
    else
      changeset
    end
  end

  defp lowercase_email(changeset) do
    case changeset.changes do
      %{ email: email } ->
        change(changeset, %{ email: String.downcase(email) })
      _ -> changeset
    end
  end

  defp passwords_match(changeset) do
    if get_change(changeset, :password_confirmation) != get_change(changeset, :password) do
      add_error(changeset, :password, "'password' does not match 'password confirmation'")
    else
      changeset
    end
  end
end
