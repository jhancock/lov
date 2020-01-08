defmodule Lov.Image do
  use Lov.Schema
  import Ecto.Changeset

  @upload_directory Application.get_env(:lov, :upload_directory)

  schema "images" do
    field :type, :string
    field :size, :integer
    # name is the original name as seen by the file uploader.  it is not used.
    # the files on the server are named by UUIDs
    field :name, :string
    field :kite_id, Ecto.UUID
    field :web_id, Ecto.UUID
    field :thumbnail_id, Ecto.UUID
    belongs_to :user, Lov.User
    timestamps()
  end

  @doc false
  def changeset(image, attrs) do
    image
    |> cast(attrs, [:user_uuid, :filename, :size, :content_type, :original_uuid, :kite_uuid, :web_uuid, :thumbnail_uuid])
    |> validate_required([:user_uuid, :filename, :size, :content_type, :original_uuid, :kite_uuid, :web_uuid, :thumbnail_uuid])
  end

  def uuid_filepath(uuid) do
    [@upload_directory, "#{uuid}.jpg"]
    |> Path.join()
  end

  def file_path(file_name) do
    [@upload_directory, "spicyplant51/#{file_name}"]
    |> Path.join()
  end

  def create_kite_image(%__MODULE__{type: "image/" <> _img_type}=image) do
    {:ok, new_image_uuid} = resize_and_crop(image, "1795x1287")
    changeset(image, %{kite_uuid: new_image_uuid})
  end  

  def create_thumbnail_image(%__MODULE__{type: "image/" <> _img_type}=image) do
    {:ok, new_image_uuid} = resize_and_crop(image, "416x300")
    changeset(image, %{thumbnail_uuid: new_image_uuid})
  end  

  def resize_and_crop(image, new_size) do
    # new_size should be a string of dimenswions.  e.g. "1795x1287"
    # https://www.imagemagick.org/Usage/resize/#fill
    original_image_path = uuid_filepath(image.original_uuid)
    new_image_uuid = Ecto.UUID.generate()
    new_image_path = uuid_filepath(new_image_uuid)
    args = ["#{original_image_path}", "-resize", "#{new_size}^", "-gravity", "center",
            "-crop", "1#{new_size}+0+0", "+repage", new_image_path]

    case System.cmd("convert", args, stderr_to_stdout: true) do
      {_, 0} -> {:ok, new_image_uuid}  
      {reason, _} -> {:error, reason}
    end
  end

end
