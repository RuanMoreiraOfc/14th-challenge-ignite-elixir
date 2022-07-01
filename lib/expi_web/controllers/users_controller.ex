defmodule ExpiWeb.UsersController do
  use ExpiWeb, :controller

  alias Expi.User
  alias Expi.Users.Create
  alias ExpiWeb.Auth.Guardian
  alias ExpiWeb.FallbackController

  action_fallback FallbackController

  def create(conn, params) do
    with {:ok, %User{} = user} <- Create.call(params),
         {:ok, token, _claims} <- Guardian.encode_and_sign(user) do
      conn
      |> put_status(:created)
      |> render("create.json", user: user, token: token)
    end
  end
end
