defmodule NflRushingWeb.PageLiveTest do
  use NflRushingWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, "/")
    assert disconnected_html =~ "<h2 class=\"text-2xl font-semibold\">Players</h2>"
    assert render(page_live) =~ "<h2 class=\"text-2xl font-semibold\">Players</h2>"
  end
end
