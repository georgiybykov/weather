defmodule Weather.Helpers.CacheKeyBuilder do
  @moduledoc false

  @doc """
  Helper function to unify style for binary payload as cache key.
  """
  @spec convert(input :: binary()) :: binary()
  def convert(input) when is_binary(input) do
    input
    |> String.trim()
    |> String.downcase()
    |> String.split(~r{\s+})
    |> Enum.join("_")
  end
end
