defmodule Kite.Asset do
    # kite.ly stores assets (images) e.g. to send a postcard
    # This module is used to interface with the kite.ly API and upload the image to kite.ly's signed s3 url

    def create() do
        public_key = "pk_test_3709e9b5859e9688a7e6ba9d45c8450afecb1f61:"
        url = "https://api.kite.ly/v4.0/asset/sign/?mime_types=image/jpeg&client_asset=true"
        headers = ["Authorization": "ApiKey #{public_key}", "Accept": "Application/json; Charset=utf-8"]
        options = [ssl: [{:versions, [:'tlsv1.2']}], recv_timeout: 500]
        {:ok, response} = HTTPoison.get(url, headers, options)
        asset_map = Jason.decode!(response.body)
        {:ok, asset_map}
    end

    def url(asset_map) do
        {:ok, [asset_url | _]} = Map.fetch(asset_map, "urls")
        asset_url
    end

    def signed_request_url(asset_map) do
        {:ok, [signed_request_url | _]} = Map.fetch(asset_map, "signed_requests")
        signed_request_url
    end

    def id(asset_map) do
        {:ok, [asset_id | _]} = Map.fetch(asset_map, "asset_ids")
        asset_id
    end

    def upload_image(asset_map, image_file_path) do
        signed_request_url = signed_request_url(asset_map)
        headers = ["Content-Type": "image/jpeg", "x-amz-acl": "private"]
        # image_file_path = "/Users/jhancock/Desktop/IMG_1888.jpg"
        body = {:file, image_file_path}
        
        # default timeout was 8 seconds.  Wasn't enough.  A full minute may work ;)
        # figuring out the timeout option was odd.  This post helped https://github.com/edgurgel/httpoison/issues/215 or https://github.com/edgurgel/httpoison/issues/299
        options = [recv_timeout: 60_000]
        #options = [ssl: [{:versions, [:'tlsv1.2']}], recv_timeout: 60_0000]
        HTTPoison.put!(signed_request_url, body, headers, options)
    end

    # this is the high level public function for this module.
    def upload_image(image_file_path) do
        {:ok, asset_map} = Kite.Asset.create()
        Kite.Asset.upload_image(asset_map, image_file_path)
    end

end