defmodule Lov.Documents do
	import Ecto.Query, warn: false

	alias Lov.Repo
	alias Lov.Documents.Upload

	def get_upload!(id) do
		Upload
		|> Repo.get!(id)
	end

	def list_uploads do
		Repo.all(Upload)
	end

	def create_upload_from_plug_upload(%Plug.Upload{
		filename: filename,
		path: tmp_path,
		content_type: content_type
	}) do

		hash = 
		 	File.stream!(tmp_path, [], 2048) 
			|> Upload.sha256()

		uuid = Ecto.UUID.generate()

		Repo.transaction fn ->
			with {:ok, %File.Stat{size: size}} <- File.stat(tmp_path),
				 {:ok, upload} <-
				 	Upload.changeset(%Upload{},%{
            uuid: uuid,
				 		filename: filename,
				 		content_type: content_type,
				 		hash: hash, size: size
				 	}) |> Repo.insert(),

				 :ok <- File.cp(tmp_path, Upload.path_from_uuid(uuid)),

				 {:ok, upload} <- Upload.create_thumbnail(upload) |> Repo.update()
			do 
				upload
			else
				{:error, reason} -> 
					Repo.rollback(reason)
			end
		end			 		 
	end

end