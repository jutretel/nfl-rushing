defmodule NflRushing.DownloadServiceTest do
  use ExUnit.Case

  alias NflRushing.DownloadService

  describe "save_file_for_process" do
    test "should send message for process id in case of success" do
      DownloadService.save_file_for_process(self(), [], [])

      assert_receive {:download, {:ok, %{filename: filename}}}

      delete_test_file(filename)
    end
    test "should send message to process id in case of failure" do
      DownloadService.save_file_for_process(self(), "forcing an error", [])

      assert_receive {:download, {:error, %{filename: filename, message: message}}}
      assert message =~ "forcing an error"

      delete_test_file(filename)
    end
  end

  defp delete_test_file(filename) do
    File.rm!("test/support/files/#{filename}")
  end
end