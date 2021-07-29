defmodule NflRushing.TempFile do

  def get_complete_path(filename), do: default_path() |> Path.join(filename)

  def save_csv(filename, content, headers) do
    try do
      unless filename |> String.ends_with?(".csv"), do: raise "Please, add .csv to our filename: #{filename}"

      filepath = get_complete_path(filename)

      content
      |> CSV.encode(headers: headers)
      |> Stream.into(File.stream!(filepath))
      |> Stream.run

      {:ok, filename}
    rescue e ->
      {:error, Map.get(e, :message, "#{inspect e}")}
    end
  end

  defp default_path(), do: Application.get_env(:nfl_rushing, :download_path, "tmp/")
end