defmodule ExpiWeb.Auth.Guardian do
  use Guardian, otp_app: :expi

  alias Expi.Error
  alias Expi.User
  alias Expi.Users.Get, as: UserGet

  @ttl {1, :minutes}

  @impl true
  def subject_for_token(%User{id: id}, _claims), do: {:ok, id}

  @impl true
  def resource_from_claims(claims) do
    claims
    |> Map.get("sub")
    |> UserGet.by_id()
  end

  @impl true
  def after_encode_and_sign(resource, claims, token, _options) do
    with {:ok, _} <- Guardian.DB.after_encode_and_sign(resource, claims["typ"], claims, token) do
      {:ok, token}
    end
  end

  @impl true
  def on_verify(claims, token, _options) do
    with {:ok, _} <- Guardian.DB.on_verify(claims, token) do
      {:ok, claims}
    end
  end

  @impl true
  def on_refresh({old_token, old_claims}, {new_token, new_claims}, _options) do
    with {:ok, _, _} <- Guardian.DB.on_refresh({old_token, old_claims}, {new_token, new_claims}) do
      {:ok, {old_token, old_claims}, {new_token, new_claims}}
    end
  end

  @impl true
  def on_revoke(claims, token, _options) do
    with {:ok, _} <- Guardian.DB.on_revoke(claims, token) do
      {:ok, claims}
    end
  end

  def authenticate(%{"id" => id, "password" => password}) do
    with {:ok, %User{password_hash: hash} = user} <- UserGet.by_id(id),
         true <- Pbkdf2.verify_pass(password, hash),
         {:ok, token, _claims} <- generate_token(user) do
      {:ok, token}
    else
      false ->
        "Please verify your credentials!"
        |> Error.build_unauthorized()
        |> Error.wrap()

      error ->
        error
    end
  end

  def authenticate(_) do
    "Invalid or missing params"
    |> Error.build_bad_request()
    |> Error.wrap()
  end

  def generate_token(%User{} = user) do
    encode_and_sign(user, %{}, ttl: @ttl)
  end

  def refresh_token(old_token) do
    {:ok, _old_token_info, {new_token, _claims}} = refresh(old_token, ttl: @ttl)
    {:ok, new_token}
  end
end
