defmodule Expi.Github.Behaviour do
  alias Expi.Error
  alias Expi.Github.Response

  @typep successful_call :: {:ok, [Response.t()]}
  @typep failing_call :: {:error, Error.t()}

  @callback get_repos(String.t()) :: successful_call | failing_call
end
