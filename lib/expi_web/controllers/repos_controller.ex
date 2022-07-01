defmodule ExpiWeb.ReposController do
  use ExpiWeb, :controller

  alias ExpiWeb.FallbackController

  action_fallback FallbackController

  def repos(conn, %{"user" => user}) do
    with {:ok, list} <- client().get_repos(user) do
      repos = Enum.map(list, &Map.from_struct/1)

      conn
      |> put_status(:ok)
      |> render("repos.json", repos: repos)
    end
  end

  defp client do
    :expi
    |> Application.fetch_env!(__MODULE__)
    |> Keyword.get(:github_adapter)
  end
end
