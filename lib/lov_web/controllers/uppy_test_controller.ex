defmodule LovWeb.UppyTestController do
  use LovWeb, :controller

  def dashboard_tus_io(conn, _params) do
    render(conn, "dashboard_tus_io.html", layout: false)
  end

  def simple_tus_io(conn, _params) do
    render(conn, "simple_tus_io.html", layout: false)
  end

  def simple_lov_is(conn, _params) do
    render(conn, "simple_lov_is.html", layout: false)
  end
end
