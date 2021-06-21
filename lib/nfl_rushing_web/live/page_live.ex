defmodule NflRushingWeb.PageLive do
  use NflRushingWeb, :live_view

  alias NflRushingWeb.Players

  def mount(_params, _session, socket) do
    players = Players.get_all()
    socket = assign(socket, players: players)

    {:ok, socket}
  end
end
