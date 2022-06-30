defmodule ExpiWeb.ReposView do
  use ExpiWeb, :view

  def render("repos.json", %{repos: repos}) when is_list(repos) do
    %{
      repos: repos
    }
  end
end
