defmodule NflRushingWeb.PageControllerTest do
  use NflRushingWeb.ConnCase
  use ExUnit.Case

  describe "download" do
    test "should download file", %{conn: conn} do
      conn = get conn, Routes.page_path(conn, :download, "players.csv")

      expected_content = "column1,column2\r\nvalue1,value2\r\n"
      assert response(conn, 200) =~ expected_content
    end
  end
end
