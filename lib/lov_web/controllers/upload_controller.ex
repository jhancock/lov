defmodule LovWeb.UploadController do
  use LovWeb, :controller

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"upload" => %Plug.Upload{}=upload}) do
    IO.inspect(upload, label: "UPLOAD")
    text conn, "ok"
  end
end