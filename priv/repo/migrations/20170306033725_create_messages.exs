defmodule WeirdStuff.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :body, :string, null: false
      add :sender_id, references(:users, type: :uuid)
      add :receiver_id, references(:users, type: :uuid)

      timestamps()
    end

    create index(:messages, [:receiver_id])
    create index(:messages, [:sender_id])
  end
end
