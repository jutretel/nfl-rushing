defmodule NflRushing.DownloadService do
  use GenServer

  alias NflRushing.TempFile

  @impl true
  def init(opts), do: {:ok, opts}
  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  @doc """
  Save a content with headers to a temporary file for a running process.
  When finished, will send a :download message back, so the process calling this function must implement the callbacks.
  """
  def save_file_for_process(process_id, file_content, file_headers) do
    GenServer.cast(__MODULE__, {:save_temp_file, process_id, file_content, file_headers})
  end

  @impl true
  def handle_cast({:save_temp_file, process_id, content, headers}, state) do
    filename = "download_#{:erlang.phash2(process_id)}.csv"

    case TempFile.save_csv(filename, content, headers) do
      {:ok, filename} -> send(process_id, {:download, {:ok, %{filename: filename}}})
      {:error, message} -> send(process_id, {:download, {:error, %{filename: filename, message: message}}})
    end

    {:noreply, state}
  end
end