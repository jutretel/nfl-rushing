defmodule NflRushingWeb.PageController do
  use NflRushingWeb, :controller
  alias NflRushing.TempFile

  def download(conn, _params = %{"filename" => filename}) do
    filepath = TempFile.get_complete_path(filename)

    if filepath |> File.exists?() do
      conn
      |> put_resp_header("content-disposition", "attachment; filename=players.csv")
      |> send_file(200, filepath)
    else
      conn
      |> put_flash(:error, "File not found, please try again later")
      |> redirect(to: "/")
    end
  end
end
