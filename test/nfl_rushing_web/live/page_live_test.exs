defmodule NflRushingWeb.PageLiveTest do
  use NflRushingWeb.ConnCase

  import Phoenix.LiveViewTest

  test "search by player name filters dataset", %{conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, "/")

    assert disconnected_html =~ "Shaun Hill"
    assert disconnected_html =~ "Joe Banyard"

    connected_html = render_submit(page_live, :search, %{"player" => "shaun", "sort_by" => ""})

    assert connected_html =~ "Shaun Hill"
    refute connected_html =~ "Joe Banyard"
  end

  test "search by player name with no match shows message", %{conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, "/")

    assert disconnected_html =~ "Shaun Hill"
    assert disconnected_html =~ "Joe Banyard"

    assert render_submit(page_live, :search, %{"player" => "blablabla", "sort_by" => ""}) =~ "No players found for <b>blablabla</b> :("
  end
end
