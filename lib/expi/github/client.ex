defmodule Expi.Github.Client do
  @behaviour Expi.Github.Behaviour

  use Tesla

  alias Expi.Error
  alias Expi.Github.Response
  alias Tesla.Env

  @url_without_user "https://api.github.com/users/#/repos"

  plug Tesla.Middleware.JSON

  @impl true
  def get_repos(url \\ @url_without_user, user) do
    fixed_url = Regex.replace(~r'/#/', url, "/#{user}/")

    fixed_url
    |> get()
    |> handle_get()
  end

  defp handle_get({:ok, %Env{status: 200, body: body}}) do
    Enum.map(body, fn item ->
      Response.build(item)
    end)
  end

  defp handle_get({:ok, %Env{status: 404}}) do
    Error.build_repos_not_found_error()
    |> Error.wrap()
  end

  defp handle_get({:error, reason}) do
    reason
    |> Error.build_bad_request()
    |> Error.wrap()
  end
end
