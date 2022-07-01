defmodule Expi.User do
  use Ecto.Schema

  import Ecto.Changeset

  alias Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @displayable_params [:id]
  @required_params [:password]
  @derive {Jason.Encoder, only: [] ++ @displayable_params}

  schema "users" do
    field :password, :string, virtual: true
    field :password_hash, :string
  end

  def changeset(params) do
    %__MODULE__{}
    |> build_changeset(params, @required_params)
  end

  defp build_changeset(struct, params, fields) do
    struct
    |> cast(params, fields)
    |> validate_required(fields)
    |> put_password_hash()
  end

  defp put_password_hash(%Changeset{valid?: true, changes: %{password: password}} = old_changeset) do
    change(old_changeset, Pbkdf2.add_hash(password))
  end

  defp put_password_hash(old_changeset), do: old_changeset
end
