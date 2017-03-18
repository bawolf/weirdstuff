defmodule WeirdStuff.DeviceController do
  use WeirdStuff.Web, :controller

  alias WeirdStuff.{Repo, User, Message, Device}

  plug :authorize_and_assign_user

  def new(conn, %{"user_id" => user_id}) do
    user = Repo.get!(User, user_id)
    changeset = Device.changeset(%Device{})
    render(conn, "new.html", changeset: changeset, user: user)
  end

  def create(conn, %{"user_id" => user_id, "device" => %{ "name" => name, "code" => code } }) do
    device_params = %{name: name, code: code, owner_id: user_id}
    changeset = Device.changeset(%Device{}, device_params)

    case Repo.insert(changeset) do
      {:ok, _device} ->
        conn
        |> put_flash(:info, "Device added successfully.")
        |> redirect(to: user_path(conn, :show, user_id))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def delete(conn, %{"user_id" => user_id, "id" => id}) do
    device = Repo.get!(Device, id)

    Repo.delete!(device)

    conn
    |> put_flash(:info, "Device deleted successfully.")
    |> redirect(to: user_path(conn, :show, user_id))
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
