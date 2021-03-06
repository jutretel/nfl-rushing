defmodule NflRushingWeb.Players do
  @sort_options %{
    "Player": "Player",
    "Total Rushing Yards": "Yds",
    "Longest Rush": "Lng",
    "Total Rushing Touchdowns": "TD",
  }

  @order_options [:asc, :desc]

  @json_keys [
    "Player", "Team", "Pos", "Att/G", "Att", "Yds", "Avg", "Yds/G", "TD", "Lng", "1st", "1st%", "20+", "40+", "FUM",
  ]

  def sort_options(), do: @sort_options
  def order_options(), do: @order_options
  def get_csv_header(), do: @json_keys

  @doc """
  Get all players matching the given criteria.
  The available types of criteria are:
  - `search_by`: keyword list with the field to be searched as the key and the expected as value.
  - `sort_by`: list with the fields to sort by. Default to sort by player's name.
  - `order`: :asc or :desc to order.

  Example:

  [search_by: ["Player": "name"], sort_by: ["Yds", "Lng"], order: :asc]
  """
  def get_all(criteria \\ []) do
    file_path = Application.get_env(:nfl_rushing, :data_source_path, "")
    content = File.read!(file_path)

    search_by = criteria[:search_by] || []
    sort_by = criteria[:sort_by] || ["Player"]
    order = sanitize_order(criteria[:order])

    Jason.decode!(content)
    |> Stream.map(&normalize/1)
    |> Stream.filter(&apply_filters(search_by, &1))
    |> Enum.sort_by(&apply_sorters(sort_by, &1), order)
  end

  defp sanitize_order(order) when order in @order_options, do: order
  defp sanitize_order(_), do: :asc

  defp apply_filters(filters, player) do
    filters = Enum.map(filters, fn
      {:Player, expected} -> contains?(player["Player"], expected)
      {key, _} -> raise "Filter not implemented for #{key}"
    end)

    Enum.all?(filters)
  end

  defp contains?(string1, string2), do: String.contains?(String.downcase(string1), String.downcase(string2))

  defp apply_sorters(sorters, player), do: sorters |> Enum.map(&(player[&1])) |> List.to_tuple

  defp normalize(player) do
    rush_info = %{
      "Lng" => longest_rush_to_int(player["Lng"]),
      "TLng" => longest_rush_touchdown(player["Lng"]),
      "Yds" => field_to_int(player["Yds"]),
      "TD" => field_to_int(player["TD"]),
    }

    Map.merge(player, rush_info)
  end

  defp longest_rush_to_int(longest_rush) when is_binary(longest_rush), do: longest_rush |> String.replace("T", "") |> String.to_integer()
  defp longest_rush_to_int(longest_rush), do: longest_rush

  defp longest_rush_touchdown(longest_rush) when is_binary(longest_rush), do: longest_rush |> String.contains?("T")
  defp longest_rush_touchdown(_longest_rush), do: false

  defp field_to_int(field) when is_binary(field), do: field |> String.replace(",", "") |> String.to_integer
  defp field_to_int(field) when is_integer(field), do: field
  defp field_to_int(_), do: raise "Field should be integer"
end
