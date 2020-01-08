defmodule LovWeb.TusdController do
  require Logger
  use LovWeb, :controller

  alias Lov.ImageManager

  # Should only get called for event post-finish.  
  # tusd docs claims the event name will be in the header as "hook-name".
  # This doesn't seem to happen.  For now, tusd is set to call this 
  # hook only for post-finish event.  Hope we can trust it.
  def hook(conn, %{"Upload" => upload}) do
    # if get_req_header(conn, "hook-name") == "post-finish" do
    #   {:ok, body, _} = read_body(conn)
    #   Logger.debug("#{inspect(body)}")
    # end
    {:ok, tusd_id} = Map.fetch(upload, "ID")
    Logger.debug "ID => #{inspect(tusd_id)}"
    {:ok, metadata} = Map.fetch(upload, "MetaData")
    Logger.debug "METADATA => #{inspect(metadata)}"
    {:ok, upload_token} = Map.fetch(metadata, "upload_token")
    Logger.debug "UPLOAD_TOKEN => #{inspect(upload_token)}"
    {:ok, name} = Map.fetch(metadata, "filename")
    Logger.debug "FILENAME => #{inspect(name)}"
    {:ok, type} = Map.fetch(metadata, "filetype")
    Logger.debug "FILETYPE => #{inspect(type)}"
    {:ok, size} = Map.fetch(upload, "Size")
    Logger.debug "SIZE => #{inspect(size)}"

    user_id = upload_token
    # add some async here. a spawn should do
    create_image_from_tusd(user_id, tusd_id, name, type, size)

    # extract user_id from tusd metadata.  
    # this needs to be passed from uppy,js

    send_resp(conn, 200, "thanks tusd ;)")
  end

  def create_image_from_tusd(user_id, tusd_id, name, type, size) do
    # need to create image and save it to get the uuid of the file
    # mv tusd_path.info, new_filepath.info
    # mv tusd_path, new_filepath
    # ImageManager.create_image(user_id, name, type, size)
  end

end