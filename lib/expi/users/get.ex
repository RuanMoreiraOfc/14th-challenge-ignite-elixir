defmodule Expi.Users.Get do
  alias Expi.{Error, Repo, User}

  def by_id(id) do
    case Repo.get(User, id) do
      %User{} = user ->
        {:ok, user}

      nil ->
        Error.build_user_not_found_error()
        |> Error.wrap()
    end
  end
end
