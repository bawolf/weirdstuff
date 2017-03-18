defmodule WeirdStuff.MessageDeviceView do
  use WeirdStuff.Web, :view

  def render("index.json", %{message: message}) do
    render_one(message, WeirdStuff.MessageDeviceView, "message.json")
  end

  def render("message.json", %{message: message}) do
    %{message: message.body}
  end

  def render("error.json", %{messages: messages}) do
    %{errors: messages}
  end
end
