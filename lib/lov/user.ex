defmodule Lov.User do
  use Lov.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    has_many :images, Lov.Image
  end

end