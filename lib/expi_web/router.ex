defmodule ExpiWeb.Router do
  use ExpiWeb, :router

  alias ExpiWeb.Auth.Pipeline, as: AuthPipeline
  alias ExpiWeb.Plugs.RefreshToken, as: RefreshTokenPlug

  # coveralls-ignore-start
  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {ExpiWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end
  # coveralls-ignore-stop

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug AuthPipeline
    plug RefreshTokenPlug
  end

  # Other scopes may use custom stacks.
  scope "/api", ExpiWeb do
    pipe_through :api

    get "/repos/:user", ReposController, :repos
    post "/users/", UsersController, :create
    post "/users/login", UsersController, :login
  end

  scope "/api", ExpiWeb do
    pipe_through [:api, :auth]

    get "/users/:id", UsersController, :show
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  # coveralls-ignore-start
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: ExpiWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  # coveralls-ignore-stop
end
