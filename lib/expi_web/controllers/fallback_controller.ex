defmodule ExpiWeb.FallbackController do
  use ExpiWeb, :controller

  alias Expi.Error
  alias ExpiWeb.ErrorView

  def call(conn, {:error, %Error{result: result, status: status}}) do
    conn
    |> put_status(status)
    |> put_view(ErrorView)
    |> render("error.json", result: result)
  end
end
