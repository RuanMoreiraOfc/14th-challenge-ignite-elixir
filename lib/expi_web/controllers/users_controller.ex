defmodule ExpiWeb.UsersController do
  use ExpiWeb, :controller

  alias Expi.User
  alias Expi.Users.{Create, Get}
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

  def login(conn, params) do
    with {:ok, token} <- Guardian.authenticate(params) do
      conn
      |> put_status(:ok)
      |> render("login.json", token: token)
    end
  end

  def show(conn, %{"id" => id}) do
    with {:ok, user} <- Get.by_id(id) do
      conn
      |> put_status(:ok)
      |> render("user.json", user: user)
    end
  end
end
