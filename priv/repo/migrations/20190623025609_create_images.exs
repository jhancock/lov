defmodule Lov.Repo.Migrations.CreateImages do
  use Ecto.Migration

  def change do
    create table(:images) do
      add :user_uuid, :string
      add :filename, :string
      add :size, :integer
      add :content_type, :string
      add :original_uuid, :string
      add :kite_uuid, :string
      add :web_uuid, :string
      add :thumbnail_uuid, :string

      timestamps()
    end

  end
end
