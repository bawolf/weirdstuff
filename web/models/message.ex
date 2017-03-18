defmodule WeirdStuff.Message do
  use WeirdStuff.Web, :model
  alias WeirdStuff.{ User }

  @primary_key {:id, :binary_id, autogenerate: true}
  @derive {Phoenix.Param, key: :id}

  schema "messages" do
    field :body, :string
    belongs_to :sender, User, type: :binary_id
    belongs_to :receiver, User, type: :binary_id

    timestamps()
  end

  @permitted_fields ~w(body sender_id receiver_id)

  def changeset(struct, params \\ %{}) do
    #validate that users are real
    struct
    |> cast(params, @permitted_fields)
    |> validate_required(@permitted_fields |> Enum.map(fn(x) -> String.to_atom(x) end))
  end
end
