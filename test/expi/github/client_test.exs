defmodule Expi.Github.ClientTest do
  use ExUnit.Case, async: true

  alias Plug.Conn
  alias Expi.Error
  alias Expi.Github.{Client, Response}

  describe "get_repos/1" do
    setup do
      bypass = Bypass.open()
      base_url = "http://localhost:#{bypass.port}/#/repos"
      user = "ruanmoreiraofc"

      {:ok, bypass: bypass, base_url: base_url, user: user}
    end

    test "returns repos when `user` is valid", %{bypass: bypass, base_url: base_url, user: user} do
      expect_body = ~s([
        {
          "id": 1,
          "name": "name",
          "html_url": "html_url",
          "description": "description",
          "stargazers_count": 0
        },
        {
          "id": 0,
          "name": "name",
          "html_url": "html_url",
          "description": "description",
          "stargazers_count": 0
        }
      ])

      expect_response = {
        :ok,
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
      }

      Bypass.expect(bypass, "GET", "/#{user}/repos", fn conn ->
        conn
        |> Conn.put_resp_content_type("application/json")
        |> Conn.resp(200, expect_body)
      end)

      response = Client.get_repos(base_url, user)

      assert response == expect_response
    end

    test "fails to return repos when `user` have not been found", %{
      bypass: bypass,
      base_url: base_url,
      user: user
    } do
      expect_response = {
        :error,
        %Error{
          status: :not_found,
          result: "No Repos were found!"
        }
      }

      Bypass.expect(bypass, "GET", "/#{user}/repos", fn conn ->
        conn
        |> Conn.put_resp_content_type("application/json")
        |> Conn.resp(404, "")
      end)

      response = Client.get_repos(base_url, user)

      assert response == expect_response
    end

    test "fails to return repos when something fail during the request", %{
      bypass: bypass,
      base_url: base_url,
      user: user
    } do
      expect_response = {
        :error,
        %Error{
          status: :bad_request,
          result: :econnrefused
        }
      }

      Bypass.down(bypass)
      response = Client.get_repos(base_url, user)

      assert response == expect_response
    end
  end
end
