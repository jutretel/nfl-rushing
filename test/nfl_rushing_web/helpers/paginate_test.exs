defmodule NflRushingWeb.Helpers.PaginateTest do
  use ExUnit.Case

  alias NflRushingWeb.Helpers.Paginate

  describe "paginate" do
    @input_data [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]

    test "should chunk data into pages" do
      page = @input_data |> Paginate.paginate(page_number: 1, page_size: 1)
      assert page == [1]
    end

    test "should get correct page" do
      page = @input_data |> Paginate.paginate(page_number: 4, page_size: 1)
      assert page == [4]
    end

    test "should get correct page for more than one element" do
      page = @input_data |> Paginate.paginate(page_number: 2, page_size: 2)
      assert page == [3, 4]
    end

    test "should return correct total of pages" do
      total = @input_data |> Paginate.total_pages(_page_size = 2)
      assert total == 6
    end
  end
end