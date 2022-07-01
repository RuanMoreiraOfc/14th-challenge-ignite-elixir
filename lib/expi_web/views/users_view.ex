defmodule ExpiWeb.UsersView do
  use ExpiWeb, :view

  def render("create.json", %{user: user, token: token}) do
    %{
      message: "User created!",
      user: user,
      token: token
    }
  end
end
