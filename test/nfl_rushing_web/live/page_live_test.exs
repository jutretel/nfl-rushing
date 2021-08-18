defmodule NflRushingWeb.PageLiveTest do
  use NflRushingWeb.ConnCase

  import Phoenix.LiveViewTest

  test "search by player name filters dataset", %{conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, "/")

    assert disconnected_html =~ "Shaun Hill"
    assert disconnected_html =~ "Joe Banyard"

    connected_html = render_submit(page_live, :search, %{"player" => "shaun", "sort_by" => "", "page_size" => "10", "order" => "asc"})

    assert connected_html =~ "Shaun Hill"
    refute connected_html =~ "Joe Banyard"
  end

  test "search by player name with no match shows message", %{conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, "/")

    assert disconnected_html =~ "Shaun Hill"
    assert disconnected_html =~ "Joe Banyard"

    assert render_submit(page_live, :search, %{"player" => "blablabla", "sort_by" => "", "page_size" => "10", "order" => "asc"}) =~ "No players found for <b>blablabla</b> :("
  end

  test "download should consider all players regardless the page", %{conn: conn} do
    {:ok, page_live, _disconnected_html} = live(conn, "/?page_size=1")

    render_submit(page_live, :download)
    assert_push_event page_live, "download", %{url: "/download/" <> filename}, 1_000

    actual_content = NflRushing.TempFile.get_complete_path(filename) |> File.read!()

    expected_content =
      """
      Player,Team,Pos,Att/G,Att,Yds,Avg,Yds/G,TD,Lng,1st,1st%,20+,40+,FUM\r
      Breshad Perriman,BAL,WR,0.1,1,2,2,0.1,0,-2,0,0,0,0,0\r
      Joe Banyard,JAX,RB,2,2,7,3.5,7,4,7,0,0,0,0,0\r
      Joe Banyard Junior,JAX,RB,2,2,7,3.5,7,4,5,0,0,0,0,0\r
      Shaun Hill,MIN,QB,1.7,5,5,1,1.7,1,9,0,0,0,0,0\r
      """

    assert expected_content == actual_content
  end

  test "pagination should keep search params", %{conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, "/")

    assert disconnected_html =~ "Joe Banyard"

    render_submit(page_live, :search, %{"player" => "shaun", "sort_by" => "", "page_size" => "10", "order" => "asc"})

    connected_html =
      page_live
      |> element("#lower_page_next")
      |> render_click()

    assert connected_html =~ "Shaun Hill"
    refute connected_html =~ "Joe Banyard"
  end

  setup do
    temp_path = Application.get_env(:nfl_rushing, :download_path)
    Application.put_env(:nfl_rushing, :download_path, System.tmp_dir!)

    on_exit(fn -> Application.put_env(:nfl_rushing, :download_path, temp_path) end)
  end
end
