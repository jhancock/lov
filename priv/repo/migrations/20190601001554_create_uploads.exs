defmodule Lov.Repo.Migrations.CreateUploads do
  use Ecto.Migration

  def change do
    create table(:uploads) do
      add :uuid, :string
      add :filename, :string
      add :size, :integer
      add :content_type, :string
      add :hash, :string, size: 64

      timestamps()
    end

    create index(:uploads, [:hash])
    create index(:uploads, [:uuid])
  end
end
