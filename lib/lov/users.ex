defmodule Lov.Users do
  @moduledoc """
  Secondary Context for our users
  """
  # import Ecto.Query, only: [from: 2]
  # import Ecto.Query
  alias Lov.{Repo, User}

  def find(id), do: Repo.get(User, id)

  def create(params \\ %{}) do
    %User{}
    |> User.changeset(params)
    |> Repo.insert()
  end

  def delete_all() do 
    Repo.delete_all(User)
    # from(x in User, where: x.id == ^id) |> Repo.delete_all
  end

  def count() do
    Repo.aggregate User, :count, :id
    # from u in User, select: count(u.id) |> Repo.one
  end

end