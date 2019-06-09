~defmodule Kite.Asset do
  # kite.ly stores assets (images) e.g. to send a postcard
  # This module is used to interface with kite.ly's API and upload the image to kite.ly's signed s3 url

  # alias __MODULE__
  alias Kite.ApiKeys

  # this is the high level public function for this module.
  def upload_image(image_path, api_mode) do
    {:ok, s3_signed_url, url} = create_s3_signed_url(api_mode)
    {:ok, _} = upload_image_to_s3(s3_signed_url, image_path)
    url
  end

  def create_s3_signed_url(api_mode) do
    %ApiKeys{public: public_key, secret: _} = ApiKeys.get(api_mode)
    url = "https://api.kite.ly/v4.0/asset/sign/?mime_types=image/jpeg&client_asset=true"
    headers = [
      {"authorization", "ApiKey #{public_key}"}, 
      {"accept", "application/json"}
    ]
    case Mojito.get(url, headers) do
      {:ok, %Mojito.Response{status_code: 200, body: body}} ->
        body_json = Jason.decode!(body)
        {:ok, [s3_signed_url | _]} = Map.fetch(body_json, "signed_requests")
        {:ok, [url | _]} = Map.fetch(body_json, "urls")
        {:ok, s3_signed_url, url}
      _ -> 
        {:error, "error creating s3 signed request url"}
    end
  end

  def upload_image_to_s3(s3_signed_url, image_path) do
    headers = [
      {"Content-Type", "image/jpeg"}, 
      {"x-amz-acl", "private"}
    ]
    payload = %{"file" => "#{image_path}"} |> Jason.encode!
    options = [timeout: 60_000]
    case Mojito.put(s3_signed_url, headers, payload, options) do
      {:ok, %Mojito.Response{status_code: 200}} ->
        {:ok, "upload_image_to_s3 SUCCESS"}
      _ ->
        {:error, "upload_image_to_s3 ERROR"}
    end
  end

  def test_upload_image() do
    upload_image("/Users/jhancock/Desktop/IMG_1888.jpg", :test)
  end

  # def create() do
  #     public_key = "pk_test_3709e9b5859e9688a7e6ba9d45c8450afecb1f61"
  #     url = "https://api.kite.ly/v4.0/asset/sign/?mime_types=image/jpeg&client_asset=true"
  #     headers = ["Authorization": "ApiKey #{public_key}", "Accept": "application/json; charset=utf-8"]
  #     options = [ssl: [{:versions, [:'tlsv1.2']}], recv_timeout: 5_000]
  #     {:ok, response} = HTTPoison.get(url, headers, options)
  #     asset_map = Jason.decode!(response.body)
  #     {:ok, asset_map}
  # end

  # # this is the high level public function for this module.
  # def upload_image(image_file_path) do
  #     {:ok, asset_map} = create()
  #     upload_image(asset_map, image_file_path)
  #     url(asset_map)
  # end

  # def upload_image_to_s3_httpoison(s3_signed_url, image_path) do
  #     headers = ["Content-Type": "image/jpeg", "x-amz-acl": "private"]
  #     body = {:file, image_path}
  #     # default timeout of 8 seconds wasn't enough.  A full minute may work ;)
  #     # This post helped https://github.com/edgurgel/httpoison/issues/215 or https://github.com/edgurgel/httpoison/issues/299
  #     options = [ssl: [{:versions, [:'tlsv1.2']}], recv_timeout: 60_000]
  #     HTTPoison.put!(s3_signed_url, body, headers, options)
  # end

  # def url(asset_map) do
  #     {:ok, [asset_url | _]} = Map.fetch(asset_map, "urls")
  #     asset_url
  # end

  # def signed_request_url(asset_map) do
  #     {:ok, [signed_request_url | _]} = Map.fetch(asset_map, "signed_requests")
  #     signed_request_url
  # end

  # def id(asset_map) do
  #     {:ok, [asset_id | _]} = Map.fetch(asset_map, "asset_ids")
  #     asset_id
  # end
end