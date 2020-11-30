defmodule ChatServerWeb.PageController do
  use ChatServerWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
