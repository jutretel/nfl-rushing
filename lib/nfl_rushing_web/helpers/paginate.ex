defmodule NflRushingWeb.Helpers.Paginate do
  @doc """
  Paginate list of elements.
  The page options expected are: `page_number` and `page_size`. Default to bring first page (1) paginated by 10 elements per page.

  Example:

  paginate(list, page_number: 1, page_size: 10)
  """
  def paginate(list, options \\ []) do
    page_number = options[:page_number] || 1
    page_size = options[:page_size] || 10

    list
    |> Stream.drop((page_number - 1) * page_size)
    |> Stream.take(page_size)
    |> Enum.to_list
  end

  @doc """
  Returns the total number of pages for a page_size.

  Example:

  total_pages(list, 2)
  """
  def total_pages(list, page_size) do
    Enum.count(list) / page_size |> ceil()
  end
end