defmodule NflRushingWeb.Players do
  def get_all() do
    content = File.read!("rushing.json")
    Jason.decode!(content)
  end
end