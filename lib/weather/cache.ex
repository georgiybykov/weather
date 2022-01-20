defmodule Weather.Cache do
  @moduledoc """
  Implements simple cache functionality dependent on ETS.
  """

  @table :weather_data_table
  @default_ttl_sec 300
  @func_arity 0

  @doc """
  Creates a new ETS Cache if it doesn't already exist.
  """
  @spec start() :: :ok | {:error, :already_started}
  def start do
    :ets.new(@table, [:set, :public, :named_table])
    :ok
  rescue
    ArgumentError ->
      {:error, :already_started}
  end

  @doc """
  Fetches a value from the cache.
  """
  @spec get(key :: any(), value :: number()) :: any()
  def get(key, ttl \\ @default_ttl_sec) do
    case :ets.lookup(@table, key) do
      [{^key, value, ts}] ->
        if current_timestamp() - ts <= ttl do
          value
        end

      _else ->
        nil
    end
  end

  @doc """
  Puts a value into the cache.
  """
  @spec put(key :: any(), value :: any()) :: :ok
  def put(key, value) do
    true = :ets.insert(@table, {key, value, current_timestamp()})
    :ok
  end

  @doc """
  Deletes a value from the cache.
  """
  @spec delete(key :: any()) :: :ok
  def delete(key) do
    true = :ets.delete(@table, key)
    :ok
  end

  @doc """
  Tries to get a value from the cache if it exists.
  Otherwise, puts it into the cache and return the result.
  """
  @spec fetch(key :: any(), ttl :: number(), resolver :: (() -> any())) :: {:ok, any()}
  def fetch(key, ttl \\ @default_ttl_sec, resolver) when is_function(resolver, @func_arity) do
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

  @spec current_timestamp() :: integer()
  defp current_timestamp, do: DateTime.to_unix(DateTime.utc_now())
end
