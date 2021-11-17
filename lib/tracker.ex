defmodule Learn.Tracker do
  use GenServer

  #======== client ========#

  def start_link(count \\ 0) do
    GenServer.start_link(__MODULE__, count, name: __MODULE__)
  end

  def increment() do
    GenServer.cast(__MODULE__, :increment)
  end

  def curr_count() do
    GenServer.call(__MODULE__, :count)
  end

  #======== Callbacks ========#

  def init(count), do: {:ok, count}

  def handle_cast(:increment, count) do
    {:noreply, count + 1}
  end

  def handle_call(:count, _from, count) do
    {:reply, count, count}
  end
end
