defmodule LovWeb.PageController do
  use LovWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

end
