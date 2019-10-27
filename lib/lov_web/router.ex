defmodule LovWeb.Router do
  use LovWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", LovWeb do
    pipe_through :browser

    # get "/", PageController, :index
    get "/", PostcardController, :index

    get "/test", PostcardController, :test

    get "/uppy-test/dashboard-tus-io", UppyTestController, :dashboard_tus_io
    get "/uppy-test/simple-tus-io", UppyTestController, :simple_tus_io
    get "/uppy-test/simple-lov-is", UppyTestController, :simple_lov_is

    get "/spicyplant51/:file_name", UploadController, :spicyplant51
    
    resources "/uploads", UploadController, only: [:index, :create, :show] do
      get "/thumbnail", UploadController, :thumbnail, as: "thumbnail"
      get "/original", UploadController, :original, as: "original"
      get "/kite", UploadController, :original, as: "kite"
    end    
  end

  # Other scopes may use custom stacks.
  # scope "/api", LovWeb do
  #   pipe_through :api
  # end
end
