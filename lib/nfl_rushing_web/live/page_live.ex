defmodule NflRushingWeb.PageLive do
  use NflRushingWeb, :live_view

  alias NflRushingWeb.Players

  def mount(_params, _session, socket) do
    players = Players.get_all()
    sort_options = Players.sort_options()
    options = %{player: "", sort_by: "Player"}

    socket = assign(socket, players: players, sort_options: sort_options, user_options: options)

    {:ok, socket}
  end

  def handle_event("search", %{"player" => player, "sort_by" => sort_by}, socket) do
    Players.get_all(search_by: ["Player": player], sort_by: [sort_by])
    |> case do
      [] ->
        socket = assign(socket, players: [], user_options: %{player: player, sort_by: sort_by})
        {:noreply, socket}

      players ->
        socket = assign(socket, players: players, user_options: %{player: player, sort_by: sort_by})
        {:noreply, socket}
    end
  end
end
