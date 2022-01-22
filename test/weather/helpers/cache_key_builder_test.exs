defmodule Weather.Helpers.CacheKeyBuilderTest do
  use Weather.DataCase, async: true

  alias Weather.Helpers.CacheKeyBuilder

  describe "#string_to_atom_key" do
    test "when param is not a binary type" do
      assert_raise FunctionClauseError, fn ->
        CacheKeyBuilder.string_to_atom_key(1)
      end
    end

    test "when the parameter type is valid, it converts it to an atom key" do
      assert CacheKeyBuilder.string_to_atom_key(" nEw  city To sEArch  ") == :new_city_to_search
    end
  end
end
