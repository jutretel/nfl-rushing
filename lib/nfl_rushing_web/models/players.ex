defmodule NflRushingWeb.Players do
  def get_all() do
    file_path = Application.get_env(:nfl_rushing, :data_source_path, "")
    content = File.read!(file_path)
    Jason.decode!(content)
  end

  def search_by_name(name) do
    get_all()
    |> Enum.filter(fn player ->
      name = name |> String.downcase()
      player["Player"] |> String.downcase() |> String.contains?(name)
    end)
  end
end