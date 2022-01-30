defmodule Weather.Cache do
  @moduledoc """
  Implements simple cache functionality dependent on ETS.
  """

  use GenServer

  @table :weather_data_table
  @default_ttl_sec 300
  @func_arity 0

  @spec start_link(any()) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @doc """
  Tries to get a value from the cache if it exists.
  Otherwise, puts it into the cache and return the result.
  """
  @spec fetch(key :: any(), ttl :: number(), resolver :: (() -> any())) :: {:ok, any()}
  def fetch(key, ttl \\ @default_ttl_sec, resolver) when is_function(resolver, @func_arity) do
    key = if is_binary(key), do: convert(key), else: key

    case get(key, ttl) do
      nil ->
        with result <- resolver.() do
          put(key, result)
          {:ok, result}
        end

      term ->
        {:ok, term}
    end
  end

  @doc """
  Gets a value from the cache.
  """
  @spec get(key :: any(), ttl :: non_neg_integer()) :: any()
  def get(key, ttl \\ @default_ttl_sec) do
    GenServer.call(__MODULE__, {:get, key, ttl})
  end

  @doc """
  Puts a value into the cache.
  """
  @spec put(key :: any(), value :: any()) :: :ok
  def put(key, value) do
    GenServer.call(__MODULE__, {:put, key, value})
  end

  @doc """
  Deletes a value from the cache.
  """
  @spec delete(key :: any()) :: :ok
  def delete(key) do
    GenServer.call(__MODULE__, {:delete, key})
  end

  # GenServer callbacks.

  @impl true
  def init(state) do
    :ets.new(
      @table,
      [
        :set,
        :public,
        :named_table,
        read_concurrency: true,
        write_concurrency: true
      ]
    )

    {:ok, state}
  end

  @impl true
  def handle_call({:get, key, ttl}, _from, state) do
    result =
      case :ets.lookup(@table, key) do
        [{^key, value, ts}] ->
          if current_timestamp() - ts <= ttl do
            value
          end

        _else ->
          nil
      end

    {:reply, result, state}
  end

  @impl true
  def handle_call({:put, key, value}, _from, state) do
    true = :ets.insert(@table, {key, value, current_timestamp()})

    {:reply, :ok, state}
  end

  @impl true
  def handle_call({:delete, key}, _from, state) do
    true = :ets.delete(@table, key)

    {:reply, :ok, state}
  end

  # Cache private functions.

  @spec current_timestamp() :: integer()
  defp current_timestamp, do: DateTime.to_unix(DateTime.utc_now())

  @spec convert(key :: binary()) :: binary()
  defp convert(key) when is_binary(key) do
    key
    |> String.trim()
    |> String.downcase()
    |> String.split(~r{\s+})
    |> Enum.join("_")
  end
end
