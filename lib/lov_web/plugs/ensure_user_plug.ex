defmodule LovWeb.EnsureUserPlug do
  require Logger
  import Plug.Conn

  def init(_opts) do
    :ok
  end

  def call(conn, _) do
    Logger.debug "Here I IS"
    user_id = Plug.Conn.get_session(conn, :user_id)
    if user_id == nil do
      # configure_session(conn, renew: true)
      Logger.debug "Here I IS AGAIN"
      user_id = Ecto.UUID.generate()
      conn 
        |> put_session(:user_id, user_id)
        |> assign(:current_user_id, user_id)
        |> configure_session(renew: true)
    else
      # conn = put_resp_cookie(conn, "_lov_id", "bar")
      conn
    end
  end

end