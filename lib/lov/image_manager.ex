defmodule Lov.ImageManager do
	import Ecto.Query, warn: false

	alias Lov.Repo
  alias Lov.Image
  
  @user_uuid "7f47d085-ea97-4daf-9edb-f9e46b7b304f"

	def get_image!(id) do
		Image
		|> Repo.get!(id)
  end

  def list_images do
		Repo.all(Image)
	end
  
  def create_image_from_plug_upload(%Plug.Upload{
		filename: filename,
		path: tmp_path,
		content_type: content_type
	}) do

		original_uuid = Ecto.UUID.generate()

		Repo.transaction fn ->
			with {:ok, %File.Stat{size: size}} <- File.stat(tmp_path),
				 {:ok, image} <-
				 	Image.changeset(%Image{},%{
            user_uuid: @user_uuid,
            filename: filename,
            size: size,
            content_type: content_type,
            original_uuid: original_uuid,
				 	}) |> Repo.insert(),

				 :ok <- File.cp(tmp_path, Image.uuid_filepath(original_uuid)),
         {:ok, image} <- Image.create_kite_image(image) |> Repo.update(),
         {:ok, image} <- Image.create_thumbnail_image(image) |> Repo.update()
			do 
				image
			else
				{:error, reason} -> 
					Repo.rollback(reason)
			end
		end			 		 
	end
 

end