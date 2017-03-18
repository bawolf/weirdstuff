defmodule WeirdStuff.DeviceMessageController do
  use WeirdStuff.Web, :controller

  alias WeirdStuff.{Repo, User, Message, Device}

  def show(conn, %{"id" => code}) do
    query =
      from m in Message,
      join: o in assoc(m, :receiver),
      join: d in assoc(o, :devices),
      where: m.receiver_id == d.owner_id
             and d.code == ^code,
      limit: 1,
      order_by: [desc: :inserted_at]

    case Repo.one(query) do
      nil -> 
        conn
        |> render("error.json", %{messages: ["no device found or no messages have been sent to this user"]})
      %Message{} = message -> 
        conn
        |> render("index.json", %{message: message})
    end
  end
end
