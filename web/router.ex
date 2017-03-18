defmodule WeirdStuff.Router do
  use WeirdStuff.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", WeirdStuff do
    pipe_through :browser # Use the default browser stack

    get "/", SessionController, :new
    resources "/users", UserController do
      resources "/messages", MessageController, only: [:new, :create, :index]
      resources "/devices", DeviceController, only: [:new, :create, :delete]
    end
    resources "/sessions", SessionController, only: [:new, :create, :show]
  end

  # Other scopes may use custom stacks.
  scope "/api", WeirdStuff do
    pipe_through :api

    resources "/device_messages", DeviceMessageController, only: [:show]
  end
end
