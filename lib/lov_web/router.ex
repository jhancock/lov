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

    get "/", PageController, :index

    resources "/uploads", UploadController, only: [:index, :create, :show] do
      get "/thumbnail", UploadController, :thumbnail, as: "thumbnail"
    end    
  end

  # Other scopes may use custom stacks.
  # scope "/api", LovWeb do
  #   pipe_through :api
  # end
end
