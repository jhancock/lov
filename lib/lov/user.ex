defmodule Lov.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Lov.Image

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  # @type t :: %__MODULE__{
  #   id: binary,
  #   email: String.t(),
  #   images: [Image.t()],
  #   inserted_at: NaiveDateTime.t(),
  #   updated_at: NaiveDateTime.t()
  # }

  @required_fields []

  schema "users" do
    field :email, :string
    has_many :images, Image
    timestamps()
  end

  def changeset(%__MODULE__{} = user, attrs \\ %{}) do
    user
    |> cast(attrs, @required_fields)
  end

end