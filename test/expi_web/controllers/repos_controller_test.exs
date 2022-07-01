defmodule ExpiWeb.ReposControllerTest do
  use ExpiWeb.ConnCase

  import Mox

  alias Expi.Github.{ClientMock, Response}

  describe "repos/2" do
    test "retrieve repos from github via `conn` when user is valid", %{conn: conn} do
      param = "ruanmoreiraofc"

      expect(ClientMock, :get_repos, fn _user ->
        [
          %Response{
            id: 1,
            name: "name",
            html_url: "html_url",
            description: "description",
            stargazers_count: 0
          },
          %Response{
            id: 0,
            name: "name",
            html_url: "html_url",
            description: "description",
            stargazers_count: 0
          }
        ]
      end)

      response =
        conn
        |> get(Routes.repos_path(conn, :repos, param))
        |> json_response(:ok)

      assert %{"repos" => [%{}, %{}]} = response
    end
  end
end
