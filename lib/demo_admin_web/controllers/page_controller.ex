defmodule DemoAdminWeb.PageController do
  use DemoAdminWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
