defmodule Kite.Postcard do
  # alias __MODULE__
  alias Kite.Asset
  alias Kite.ApiKeys
  alias Kite.Address

  # address is %Address, message is String, front_image_path is a String, api_mode is :test or :live
  def send(address, message, front_image_path, api_mode) do
    # upload front_image_path to s3
    s3_asset_url = Asset.upload_image(front_image_path, api_mode)
    # print the postcard
    print_api_url = "https://api.kite.ly/v4.0/print/"
    %ApiKeys{public: public_key, secret: secret_key} = ApiKeys.get(api_mode)
    headers = [
      {"authorization", "ApiKey #{public_key}:#{secret_key}"}, 
      {"content-type", "application/json"}
    ]
    payload = create_payload(address, message, s3_asset_url) |> Jason.encode!
    Mojito.post(print_api_url, headers, payload)
  end

  def create_payload(address, message, s3_asset_url) do
    %{
      "shipping_address" => address,
      "customer_email" => "jhancock@shellshadow.com",
      "jobs" => [%{
        "assets" => %{
          "front_image" => "#{s3_asset_url}"
        },
        "template_id" => "postcard",
        "message" => "#{message}"
      }]
    }
  end

  def test_send() do
    send(Address.example, "test message", "/Users/jhancock/Desktop/IMG_1888.jpg", :test)
  end

  # def test_send(s3_asset_url, message) do
  #   public_key = "pk_test_3709e9b5859e9688a7e6ba9d45c8450afecb1f61"
  #   private_key = "sk_test_86badd869f57c6ab517f5621807c674c3dbce553"
  #   url = "https://api.kite.ly/v4.0/print/"
  #   #form_params = URI.encode_www_form(test_string())
  #   #body = {:form, form_params}
  #   body = test_body(s3_asset_url, message) |> Jason.encode!
  #   #headers = ["Authorization": "ApiKey #{public_key}:#{private_key}", "Accept": "*/*", "Content-Type": "application/json"]
  #   headers = ["Authorization": "ApiKey #{public_key}:#{private_key}", "Content-Type": "application/json"]
  #   options = [ssl: [{:versions, [:'tlsv1.2']}], recv_timeout: 10_000]
  #   # should this be in headers or does :form in body handle that? Content-Type: application/x-www-form-urlencoded
  #   HTTPoison.post!(url, body, headers, options)
  # end

  # def test_body(s3_asset_url, message) do
  #   %{
  #     "shipping_address" => %{
  #       "recipient_name" => "Jon Hancock",
  #       "address_line_1" => "157 Breaker Bay Rd",
  #       "address_line_2" => "Breaker Bay",
  #       "city" => "Wellington",
  #       "county_state" => "Wellington",
  #       "postcode" => "6022",
  #       "country_code" => "NZL"
  #     },
  #     "customer_phone" => "+64 (0)2102916167",
  #     "jobs" => [%{
  #       "assets" => %{
  #         "front_image" => "#{s3_asset_url}"
  #       },
  #       "template_id" => "postcard",
  #       "message" => "#{message}"
  #     }]
  #   }
  # end  
end