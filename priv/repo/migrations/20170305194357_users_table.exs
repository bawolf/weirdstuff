defmodule WeirdStuff.Repo.Migrations.UsersTable do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :email, :string, null: false
      add :password_digest, :string, null: false

      timestamps()
    end

    create unique_index(:users, [:email])
  end
end
