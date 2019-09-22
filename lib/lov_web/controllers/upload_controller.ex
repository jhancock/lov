defmodule LovWeb.UploadController do
  use LovWeb, :controller

  alias Lov.ImageManager
  alias Lov.Image

  def index(conn, _params) do
  	uploads = ImageManager.list_images()
  	render(conn, "index.html", uploads: uploads)
  end

  def create(conn, %{"upload" => %Plug.Upload{}=upload}) do
  	case ImageManager.create_image_from_plug_upload(upload) do
  		{:ok, _image} ->
  			conn
        |> put_flash(:info, "image uploaded correctly")
  			|> redirect(to: Routes.upload_path(conn, :index))
  		{:error, reason} ->
        conn
  			|> put_flash(:error, "error upload file: #{inspect(reason)}")
  			|> redirect(to: Routes.upload_path(conn, :index))
  	end
  end

  def show(conn, %{"id" => id}) do
    image = ImageManager.get_image!(id)
    local_path = Image.uuid_filepath(image.original_uuid)
    send_download conn, {:file, local_path}, filename: image.filename
  end

  def original(conn, %{"upload_id" => id}) do
    image = ImageManager.get_image!(id)
    local_path = Image.uuid_filepath(image.original_uuid)
    conn
    |> put_resp_content_type("image/jpeg")
    |> send_file(200, local_path)  
  end

  def thumbnail(conn, %{"upload_id" => id}) do
    thumb_path = Image.uuid_filepath(id)
    conn
    |> put_resp_content_type("image/jpeg")
    |> send_file(200, thumb_path)
  end

end