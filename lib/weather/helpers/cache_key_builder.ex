defmodule Weather.Helpers.CacheKeyBuilder do
  @moduledoc """
  Weather keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  @doc """
  Helper function to unify style for binary payload as cache key.
  """
  @spec string_to_atom_key(key :: binary()) :: atom()
  def string_to_atom_key(key) when is_binary(key) do
    key
    |> String.trim()
    |> String.downcase()
    |> String.split(~r{\s+})
    |> Enum.join("_")
    |> String.to_atom()
  end
end
