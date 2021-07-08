defmodule NflRushingWeb.PageLive do
  use NflRushingWeb, :live_view

  alias NflRushingWeb.Players
  alias NflRushingWeb.Helpers.Paginate

  def mount(_params, _session, socket) do
    sort_options = Players.sort_options()
    order_options = Players.order_options()

    socket = assign(socket, sort_options: sort_options, order_options: order_options)

    {:ok, socket, temporary_assigns: [players: []]}
  end

  def handle_params(params, _url, socket) do
    page_size = String.to_integer(params["page_size"] || "10")
    page = String.to_integer(params["page"] || "1")
    player = params["player"] || ""
    sort_by = params["sort_by"] || "Player"
    order = String.to_atom(params["order"] || "asc")

    user_options = %{player: player, sort_by: sort_by, page: page, page_size: page_size, order: order}

    players = Players.get_all(search_by: ["Player": player], sort_by: [sort_by], order: order)

    players_page = players |> Paginate.paginate(page_number: page, page_size: page_size)
    total_pages = players |> Paginate.total_pages(page_size)

    socket = assign(socket, players: players_page, total_pages: total_pages, user_options: user_options)

    {:noreply, socket}
  end

  def handle_event("search", %{"player" => player, "sort_by" => sort_by, "page_size" => page_size, "order" => order}, socket) do
    socket = push_patch(socket, to: Routes.live_path(socket, __MODULE__, page: 1, page_size: page_size, player: player, sort_by: sort_by, order: order))

    {:noreply, socket}
  end

  defp pagination_link(socket, btn_text, btn_class, page, page_size) do
    route = Routes.live_path(socket, __MODULE__, page: page, page_size: page_size)
    live_patch(btn_text, to: route, class: btn_class)
  end
end
