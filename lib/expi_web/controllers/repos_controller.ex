defmodule ExpiWeb.ReposController do
  use ExpiWeb, :controller

  def repos(conn, %{"user" => user}) do
    github_client = client()

    {:ok, repos} =
      user
      |> github_client.get_repos()

    repos =
      repos
      |> Enum.map(&Map.from_struct/1)

    conn
    |> put_status(:ok)
    |> render("repos.json", repos: repos)
  end

  defp client do
    :expi
    |> Application.fetch_env!(__MODULE__)
    |> Keyword.get(:github_adapter)
  end
end
