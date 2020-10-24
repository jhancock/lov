defmodule LovWeb.Router do
  use LovWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {LovWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug LovWeb.EnsureUserPlug
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", LovWeb do
    pipe_through :api
    post "/tusd", TusdController, :hook
  end

  scope "/", LovWeb do
    pipe_through :browser

    # live "/", PageLive, :index
    
    # this is the work in progress of lov.is before liveview
    get "/", PostcardController, :index
    # get "/", UppyTestController, :simple_stimulus

    # this is the original PageController
    # get "/", PageController, :index

    # get "/uppy-test/dashboard-tus-io", UppyTestController, :dashboard_tus_io
    # get "/uppy-test/simple-tus-io", UppyTestController, :simple_tus_io
    # get "/uppy-test/simple-lov-is", UppyTestController, :simple_lov_is
    # get "/uppy-test/simple-stimulus", UppyTestController, :simple_stimulus

    # get "/spicyplant51/:file_name", UploadController, :spicyplant51
    
    # resources "/uploads", UploadController, only: [:index, :create, :show] do
    #   get "/thumbnail", UploadController, :thumbnail, as: "thumbnail"
    #   get "/original", UploadController, :original, as: "original"
    #   get "/kite", UploadController, :original, as: "kite"
    # end    
  end

  # Other scopes may use custom stacks.
  # scope "/api", LovWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: LovWeb.Telemetry
    end
  end
end
