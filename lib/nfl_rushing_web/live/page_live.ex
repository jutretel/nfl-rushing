defmodule NflRushingWeb.PageLive do
  use NflRushingWeb, :live_view

  alias NflRushingWeb.Players

  def mount(_params, _session, socket) do
    players = Players.get_all()
    socket = assign(socket, players: players, player: "", empty_list: false)

    {:ok, socket}
  end

  def handle_event("search_player", %{"player" => player}, socket) do
    case Players.search_by_name(player) do
      [] ->
        socket = assign(socket, player: player, players: [], empty_list: true)
        {:noreply, socket}

      players ->
        socket = assign(socket, player: player, players: players, empty_list: false)
        {:noreply, socket}
    end
  end
end
