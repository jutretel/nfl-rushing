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

    test "should search and sort" do
      result =
        Players.get_all(search_by: ["Player": "Joe"], sort_by: ["Lng"])
        |> Enum.map(&(&1["Lng"]))

      assert result == [5, 7]
    end

    test "should return longest rushing yards as integer" do
      Players.get_all()
      |> Enum.each(fn player ->
        assert player["Yds"] |> is_integer()
      end)
    end
  end

  describe "searching by name" do
    test "should filter by name" do
      [filtered] = Players.get_all(search_by: ["Player": "Shaun"])
      assert filtered["Player"] == "Shaun Hill"
    end

    test "should be case insensitive" do
      [filtered] = Players.get_all(search_by: ["Player": "shaun"])
      assert filtered["Player"] == "Shaun Hill"
    end

    test "should raise error for not implemented filter" do
      assert_raise RuntimeError, "Filter not implemented for some random field", fn ->
        Players.get_all(search_by: ["some random field": ""])
      end
    end
  end

  describe "sorting by" do
    test "should sort by total rushing yards" do
      assert Players.get_all(sort_by: ["Yds"]) |> Enum.map(&(&1["Yds"])) == [2, 5, 7, 7124]
    end

    test "should sort by longest rush" do
      assert Players.get_all(sort_by: ["Lng"]) |> Enum.map(&(&1["Lng"])) == [-2, 5, 7, 9]
    end

    test "should sort by total rushing touchdowns" do
      assert Players.get_all(sort_by: ["TD"]) |> Enum.map(&(&1["TD"])) == [0, 1, 4, 4]
    end

    test "should sort by more than one field" do
      players_names =
        Players.get_all(sort_by: ["TD", "Player"])
        |> Enum.map(&(&1["Player"]))

      assert players_names == ["Breshad Perriman", "Shaun Hill", "Joe Banyard", "Joe Banyard Junior"]
    end

    test "should sort if :asc is passed" do
      assert Players.get_all(sort_by: ["Lng"], order: :asc) |> Enum.map(&(&1["Lng"])) == [-2, 5, 7, 9]
    end

    test "should sort if :desc is passed" do
      assert Players.get_all(sort_by: ["Lng"], order: :desc) |> Enum.map(&(&1["Lng"])) == [9, 7, 5, -2]
    end

    test "should sort asc if unknown order is passed" do
      assert Players.get_all(sort_by: ["Lng"], order: :bla) |> Enum.map(&(&1["Lng"])) == [-2, 5, 7, 9]
    end
  end
end
