defmodule Lov.Repo.Migrations.AddImageTable do
  use Ecto.Migration

  def change do
    create table(:images, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :type, :string
      add :size, :integer
      add :name, :string
      add :kite_id, :uuid
      add :web_id, :uuid
      add :thumbnail_id, :uuid
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)
      timestamps()
    end

    create index(:images, [:user_id])
  end
end
