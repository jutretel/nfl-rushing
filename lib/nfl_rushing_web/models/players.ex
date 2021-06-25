defmodule NflRushingWeb.Players do
  def get_all() do
    file_path = Application.get_env(:nfl_rushing, :data_source_path, "")
    content = File.read!(file_path)
    Jason.decode!(content) |> normalize() 
  end

  def search_by_name(name) do
    get_all()
    |> Enum.filter(fn player ->
      name = name |> String.downcase()
      player["Player"] |> String.downcase() |> String.contains?(name)
    end)
  end

  def sort_by(:yds), do: get_all() |> Enum.sort(&(&1["Yds"] <= &2["Yds"]))
  def sort_by(:lng), do: get_all() |> Enum.sort(&(&1["Lng"] <= &2["Lng"]))
  def sort_by(:td), do: get_all() |> Enum.sort(&(&1["TD"] <= &2["TD"]))

  defp normalize(players) do
    players
    |> Enum.map(fn player ->
      rush_info = %{
        "Lng" => longest_rush_to_int(player["Lng"]),
        "TLng" => longest_rush_touchdown(player["Lng"]),
      }
      Map.merge(player, rush_info)
    end)
  end

  defp longest_rush_to_int(longest_rush) when is_binary(longest_rush), do: longest_rush |> String.replace("T", "") |> String.to_integer()
  defp longest_rush_to_int(longest_rush), do: longest_rush

  defp longest_rush_touchdown(longest_rush) when is_binary(longest_rush), do: longest_rush |> String.contains?("T")
  defp longest_rush_touchdown(_longest_rush), do: false
end