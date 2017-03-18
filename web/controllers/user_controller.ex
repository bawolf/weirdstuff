defmodule WeirdStuff.UserController do
  use WeirdStuff.Web, :controller

  alias WeirdStuff.{User, Device, Message}

  plug :authorize_and_assign_user

  def index(conn, _params) do
    users = Repo.all(User)
    render(conn, "index.html", users: users)
  end

  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => %{"email" => email, "password" => password, "password_confirmation" => password_confirmation }}) do
    user_params = %{ email: email,
                     password: password,
                     password_confirmation: password_confirmation }

    changeset = User.changeset(%User{}, user_params)

    case Repo.insert(changeset) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: user_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Repo.get!(User, id)

    query =
      from u in User,
      where: u.id == ^id,
      preload: ^[:devices,
                received_messages: received_messages_query(id)]
    user = 
      query
      |> Repo.one

    render(conn, "show.html", user: user, devices: user.devices, messages: user.received_messages)
  end

  defp received_messages_query(id) do
    from m in Message, where: m.receiver_id == ^id, limit: 10, preload: [:sender, :receiver]
  end

  def edit(conn, %{"id" => id}) do
    user = Repo.get!(User, id)
    changeset = User.changeset(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Repo.get!(User, id)
    changeset = User.changeset(user, user_params)

    case Repo.update(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: user_path(conn, :show, user))
      {:error, changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Repo.get!(User, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: user_path(conn, :index))
  end

  defp authorize_user(conn, _opts) do
    user = get_session(conn, :current_user)
    if user do
      conn
    else
      conn
      |> put_flash(:error, "You are not authorized to view that.")
      |> redirect(to: session_path(conn, :new))
      |> halt()
    end
  end

  defp authorize_and_assign_user(conn, _opts) do
    case conn.params do
      %{"id" => user_id} ->
          if user_id == get_session(conn, :current_user).id do
            conn
          else
            conn
            |> put_flash(:error, "You are not authorized to view that.")
            |> redirect(to: user_path(conn, :index))
            |> halt()
          end
      _ ->
        conn
    end
  end
end

