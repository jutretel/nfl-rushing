defmodule NflRushing.DownloadServiceTest do
  use ExUnit.Case

  alias NflRushing.DownloadService

  describe "save_file_for_process" do
    test "should send message for process id in case of success" do
      DownloadService.save_file_for_process(self(), [], [])

      assert_receive {:download, {:ok, %{filename: _filename}}}, 1_000
    end
    test "should send message to process id in case of failure" do
      DownloadService.save_file_for_process(self(), "forcing an error", [])

      assert_receive {:download, {:error, %{filename: _filename, message: message}}}, 1_000
      assert message =~ "forcing an error"
    end
  end

  setup do
    temp_path = Application.get_env(:nfl_rushing, :download_path)
    Application.put_env(:nfl_rushing, :download_path, System.tmp_dir!)

    on_exit(fn -> Application.put_env(:nfl_rushing, :download_path, temp_path) end)
  end
end
