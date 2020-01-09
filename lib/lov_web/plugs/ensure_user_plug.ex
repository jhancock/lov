defmodule LovWeb.EnsureUserPlug do
  require Logger
  import Plug.Conn

  alias Lov.Users

  def init(_opts) do
    :ok
  end

  def call(conn, _) do
    Logger.debug "checking session cookie for user_id"
    user_id = Plug.Conn.get_session(conn, :user_id)
    if user_id == nil do
      Logger.debug "no user_id in session cookie"
      {:ok, user} = Users.create()
      Logger.debug "created new user #{inspect(user.id)}"
      conn 
        |> put_session(:user_id, user.id)
        |> configure_session(renew: true)
    else
      conn
    end
  end

end