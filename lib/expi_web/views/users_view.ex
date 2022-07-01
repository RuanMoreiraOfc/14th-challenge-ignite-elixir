defmodule ExpiWeb.UsersView do
  use ExpiWeb, :view

  def render("create.json", %{user: user, token: token}) do
    %{
      message: "User created!",
      user: user,
      token: token
    }
  end

  def render("login.json", %{token: token}) do
    %{
      token: token
    }
  end

  def render("user.json", %{user: user}) do
    %{
      user: user
    }
  end
end
