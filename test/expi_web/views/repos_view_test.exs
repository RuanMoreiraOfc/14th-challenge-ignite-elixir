defmodule ExpiWeb.ReposViewTest do
  use ExpiWeb.ConnCase, async: true

  import Phoenix.View

  alias ExpiWeb.ReposView

  test "renders repos.json" do
    repos = [
      %{
        id: 1,
        name: "name",
        html_url: "html_url",
        description: "description",
        stargazers_count: 0
      },
      %{
        id: 0,
        name: "name",
        html_url: "html_url",
        description: "description",
        stargazers_count: 0
      }
    ]

    render(ReposView, "repos.json", repos: repos)
  end
end
