defmodule LovWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :lov

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  @session_options [
    store: :cookie,
    key: "_lov_key",
    signing_salt: "xlrfgNfx"
  ]


  # not needed if nginx is in front of erlang vm
  # :plug_canonical_host needs to be in mix.exs
  # plug(:canonical_host)

  # defp canonical_host(conn, _opts) do
  #   :lov
  #   |> Application.get_env(:canonical_host)
  #   |> case do
  #     host when is_binary(host) ->
  #       opts = PlugCanonicalHost.init(canonical_host: host)
  #       PlugCanonicalHost.call(conn, opts)

  #     _ ->
  #       conn
  #   end
  # end

  socket "/socket", LovWeb.UserSocket,
    websocket: true,
    longpoll: false

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phx.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/",
    from: :lov,
    gzip: false,
    only: ~w(css fonts images js favicon.ico robots.txt)

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, {:multipart, length: 20_000_000}, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head

  plug Plug.Session, @session_options


  plug LovWeb.Router
end
