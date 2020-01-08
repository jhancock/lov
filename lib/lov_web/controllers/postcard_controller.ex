defmodule LovWeb.PostcardController do
  use LovWeb, :controller

  # alias Lov.Documents
  # alias Lov.Documents.Upload

  def index(conn, _params) do
    # uploads = Documents.list_uploads()
    # image_url = ""
    image_id = 15
  	render(conn, "index.html", image_id: image_id)
  end
end