defmodule Mix.Tasks.CreateJson do
  use Mix.Task

  @json_fields ["Player", "Team", "Pos", "Att", "Att/G", "Yds", "Avg", "Yds/G", "TD", "Lng", "1st", "1st%", "20+", "40+", "FUM"]

  @shortdoc "Creates a Json file to be used as data source with n_elements."
  def run([n_elements]) do
    players =
      Application.get_env(:nfl_rushing, :data_source_path, "")
      |> File.read!()
      |> Jason.decode!()

    new_content =
      1..(n_elements |> String.to_integer)
      |> Stream.map(&create_element(&1, players))
      |> Enum.to_list()
      |> Jason.encode!()

    File.write!("rushing_#{n_elements}.json", new_content)
  end

  defp create_element(_x, players) do
    @json_fields
    |> Enum.reduce(%{}, fn field, result ->
      result |> Map.put(field, Enum.at(players, :rand.uniform(300))[field])
    end)
  end
end