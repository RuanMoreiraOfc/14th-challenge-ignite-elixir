defmodule ExpiWeb.ReposController do
  use ExpiWeb, :controller

  alias Expi.Github.Client, as: ClientGithub

  def repos(conn, %{"user" => user}) do
    repos =
      user
      |> ClientGithub.get_repos()
      |> Enum.map(&Map.from_struct/1)

    conn
    |> put_status(:ok)
    |> render("repos.json", repos: repos)
  end
end
