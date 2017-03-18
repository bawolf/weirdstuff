require IEx

defmodule WeirdStuff.DeviceMessageController do
  use WeirdStuff.Web, :controller

  alias WeirdStuff.{Repo, User, Message, Device}

  # plug :assign_device
  # plug :authorize_user


  def show(conn, %{"id" => code}) do
    #select message from messages where the receiver is the user whose is the owner of the device with this code
    # IEx.pry


    query =
      from m in Message,
      where: m.receiver_id == ^device_query(code),
      limit: 1,
      order_by: [desc: :inserted_at]

    message = 
      query
      |> Repo.one

    render(conn, "index.html", message: message)
  end

  defp device_query(code) do
    from d in Device, where: d.code == ^code, select: d.owner_id, limit: 1
  end


  # defp assign_user(conn, _opts) do
  #   case conn.params do
  #     %{"user_id" => user_id} ->
  #       user = Repo.get(WeirdStuff.User, user_id)
  #       assign(conn, :user, user)
  #     _ ->
  #       conn
  #   end
  # end

  # defp authorize_user(conn, _opts) do
  #   current_user = get_session(conn, :current_user)
  #   if current_user do
  #     conn
  #   else
  #     conn
  #     |> put_flash(:error, "You are not authorized to view that.")
  #     |> redirect(to: session_path(conn, :new))
  #     |> halt()
  #   end
  # end

  # defp authorize_and_assign_user(conn, _opts) do
  #   case conn.params do
  #     %{"user_id" => user_id} ->
  #         if user_id == get_session(conn, :current_user).id do
  #           user = Repo.get(WeirdStuff.User, user_id)
  #           assign(conn, :user, user)
  #         else
  #           conn
  #           |> put_flash(:error, "You are not authorized to view that.")
  #           |> redirect(to: user_path(conn, :index))
  #           |> halt()
  #         end
  #     _ ->
  #       conn
  #   end
  # end
end
