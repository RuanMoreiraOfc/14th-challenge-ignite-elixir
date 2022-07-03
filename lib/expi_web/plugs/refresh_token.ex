defmodule ExpiWeb.Plugs.RefreshToken do
  import Plug.Conn

  alias ExpiWeb.Auth.Guardian
  alias Plug.Conn

  def init(options), do: options

  def call(%Conn{} = conn, _opts) do
    ["Bearer " <> old_token] = get_req_header(conn, "authorization")

    {:ok, new_token} = Guardian.refresh_token(old_token)

    put_private(conn, :expi_new_token, new_token)
  end

  def call(conn, _opts), do: conn
end
