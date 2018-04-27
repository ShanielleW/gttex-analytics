defmodule GttexAnalyticsWeb.PageController do
  use GttexAnalyticsWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
