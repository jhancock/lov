defmodule LovWeb.TusdController do
  require Logger
  use LovWeb, :controller

  # Should only get called for event post-finish.  
  # tusd docs claims the event name will be in the header as "hook-name".
  # This doesn't seem to happen.  For now, tusd is set to call this 
  # hook only for post-finish event.  Hope we can trust it.
  def hook(conn, %{"Upload" => upload}) do
    # if get_req_header(conn, "hook-name") == "post-finish" do
    #   {:ok, body, _} = read_body(conn)
    #   Logger.debug("#{inspect(body)}")
    # end
    Logger.debug "UPLOAD => #{inspect(upload)}"
    {:ok, id} = Map.fetch(upload, "ID")
    Logger.debug "ID => #{inspect(id)}"
    {:ok, metadata} = Map.fetch(upload, "MetaData")
    Logger.debug "METADATA => #{inspect(metadata)}"
    {:ok, filename} = Map.fetch(metadata, "filename")
    Logger.debug "FILENAME => #{inspect(filename)}"
    {:ok, filetype} = Map.fetch(metadata, "filetype")
    Logger.debug "FILETYPE => #{inspect(filetype)}"
    {:ok, size} = Map.fetch(upload, "Size")
    Logger.debug "SIZE => #{inspect(size)}"

    send_resp(conn, 200, "thanks tusd ;)")
  end

end