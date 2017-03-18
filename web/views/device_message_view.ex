defmodule WeirdStuff.DeviceMessageView do
  use WeirdStuff.Web, :view

  def render("index.json", %{message: message}) do
    %{message: message.body}
  end

  def render("error.json", %{messages: messages}) do
    %{errors: messages}
  end
end
