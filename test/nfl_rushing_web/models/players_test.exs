defmodule NflRushingWeb.PlayersTest do
  use ExUnit.Case

  alias NflRushingWeb.Players

  describe "get all" do
    test "should return parsed json" do
      assert Players.get_all() |> is_list()
      assert Players.get_all() |> hd() |> is_map()
    end

    test "should return longest run as integer and touchdown as boolean" do
      Players.get_all()
      |> Enum.map(fn player ->
        assert player["Lng"] |> is_integer()
        assert player["TLng"] |> is_boolean()
      end)
    end
  end

  describe "searching by name" do
    test "should filter by name" do
      [filtered] = Players.search_by_name("Shaun")
      assert filtered["Player"] == "Shaun Hill"
    end

    test "should be case insensitive" do
      [filtered] = Players.search_by_name("shaun")
      assert filtered["Player"] == "Shaun Hill"
    end
  end
end