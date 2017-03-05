defmodule WeirdStuff.PageController do
  use WeirdStuff.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
