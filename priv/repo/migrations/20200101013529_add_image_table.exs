defmodule Lov.Repo.Migrations.AddImageTable do
  use Ecto.Migration

  def change do
    create table("images") do
      add :type, :string
      add :size, :integer
      add :name, :string
      add :kite_id, :uuid
      add :web_id, :uuid
      add :thumbnail_id, :uuid
      add :user_id, references(:users)
      timestamps()
    end
  end
end
