defmodule WeirdStuff.Repo.Migrations.Devices do
  use Ecto.Migration

   def change do
    create table(:devices, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string, null: false
      add :code, :string, null: false
      add :owner_id, references(:users, type: :uuid)

      timestamps()
    end

    create index(:devices, [:owner_id])
  end
end
