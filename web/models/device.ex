defmodule WeirdStuff.Device do
  use WeirdStuff.Web, :model
  alias WeirdStuff.{ User }

  @primary_key {:id, :binary_id, autogenerate: true}
  @derive {Phoenix.Param, key: :id}

  schema "devices" do
    field :name, :string
    field :code, :string #make unique
    belongs_to :owner, User, type: :binary_id

    timestamps()
  end

  @permitted_fields ~w(name owner_id code)

  def changeset(struct, params \\ %{}) do
    #validate that users are real
    struct
    |> cast(params, @permitted_fields)
    |> validate_required(@permitted_fields |> Enum.map(fn(x) -> String.to_atom(x) end))
  end
end
