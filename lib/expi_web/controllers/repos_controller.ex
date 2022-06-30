defmodule ExpiWeb.ReposController do
  use ExpiWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
