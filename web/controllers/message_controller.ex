defmodule WeirdStuff.MessageController do
  use WeirdStuff.Web, :controller

  alias WeirdStuff.{Repo, User, Message}

  plug :authorize_and_assign_user when action in [:index]
  plug :assign_user
  plug :authorize_user


  def index(conn, %{"user_id" => user_id}) do
    query = from m in Message, where: m.receiver_id == ^user_id
    messages = 
      query
      |> Repo.all
      |> Repo.preload([:receiver, :sender])

    render(conn, "index.html", messages: messages)
  end

  def new(conn, _params) do
    changeset = Message.changeset(%Message{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{ "user_id" => user_id, "message" => %{ "body" => body } }) do
    user = Repo.get(WeirdStuff.User, user_id)
    current_user_id = get_session(conn, :current_user).id
    message_params = %{ body: body, sender_id: current_user_id, receiver_id: user.id }
    changeset = Message.changeset(%Message{}, message_params)

    case Repo.insert(changeset) do
      {:ok, _message} ->
        conn
        |> put_flash(:info, "Message sent successfully.")
        |> redirect(to: user_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  defp assign_user(conn, _opts) do
    case conn.params do
      %{"user_id" => user_id} ->
        user = Repo.get(WeirdStuff.User, user_id)
        assign(conn, :user, user)
      _ ->
        conn
    end
  end

  defp authorize_user(conn, _opts) do
    current_user = get_session(conn, :current_user)
    if current_user do
      conn
    else
      conn
      |> put_flash(:error, "You are not authorized to view that.")
      |> redirect(to: session_path(conn, :new))
      |> halt()
    end
  end

  defp authorize_and_assign_user(conn, _opts) do
    current_user = get_session(conn, :current_user)
    case conn.params do
      %{"user_id" => user_id} ->
        if user_id == get_session(conn, :current_user).id do
            conn
        else
          conn
          |> put_flash(:error, "You are not authorized to view that.")
          |> redirect(to: user_path(conn, :index))
          |> halt()
        end
      _ ->
        if current_user == nil do
          conn
          |> put_flash(:error, "You are not authorized to view that.")
          |> redirect(to: session_path(conn, :new))
          |> halt()
        else
          conn
        end
    end
  end
end
