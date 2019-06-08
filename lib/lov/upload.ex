defmodule Lov.Upload do
  use Ecto.Schema
  import Ecto.Changeset
  @upload_directory Application.get_env(:lov, :uploads_directory)

  schema "uploads" do
    field :uuid, :string
    field :content_type, :string
    field :filename, :string
    field :hash, :string
    field :size, :integer

    timestamps()
  end

  @doc false
  def changeset(upload, attrs) do
    upload
    |> cast(attrs, [:uuid, :filename, :size, :content_type, :hash])
    |> validate_required([:uuid, :filename, :size, :content_type, :hash])
    |> validate_number(:size, greater_than: 0) #doesn't allow empty files
    |> validate_length(:hash, is: 64)
  end

  def sha256(chunks_enum) do
    chunks_enum
    |> Enum.reduce(
        :crypto.hash_init(:sha256),
        &(:crypto.hash_update(&2, &1))
    ) 
    |> :crypto.hash_final()
    |> Base.encode16()
    |> String.downcase()
  end

  def local_path(id, filename) do
    [@upload_directory, "#{id}-#{filename}"]
    |> Path.join()
  end
end
