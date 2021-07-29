defmodule NflRushing.TempFileTest do
  use ExUnit.Case
  alias NflRushing.TempFile

  describe "save csv" do
    test "should return ok and filename" do
      {:ok, filename} = TempFile.save_csv("test.csv", [%{column1: "value1", column2: "value2"}], [:column1, :column2])

      expected_content = "column1,column2\r\nvalue1,value2\r\n"
      actual_content = TempFile.get_complete_path(filename) |> File.read!

      assert expected_content == actual_content
    end

    test "should return error and message" do
      {:error, message} = TempFile.save_csv("error.csv", "forcing an error", [])
      assert message == "%Protocol.UndefinedError{description: \"\", protocol: Enumerable, value: \"forcing an error\"}"
    end

    test "should return error to enforce .csv as extension" do
      {:error, message} = TempFile.save_csv("test", [], [])
      assert message == "Please, add .csv to our filename: test"
    end
  end
end