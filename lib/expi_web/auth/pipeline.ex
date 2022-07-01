defmodule ExpiWeb.Auth.Pipeline do
  use Guardian.Plug.Pipeline, otp_app: :expi

  plug Guardian.Plug.VerifyHeader
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
