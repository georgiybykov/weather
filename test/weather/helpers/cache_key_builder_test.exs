defmodule Weather.Helpers.CacheKeyBuilderTest do
  use Weather.DataCase, async: true

  alias Weather.Helpers.CacheKeyBuilder

  describe "#convert/1" do
    test "when param is not a binary type" do
      assert_raise FunctionClauseError, fn ->
        CacheKeyBuilder.convert(1)
      end
    end

    test "when the parameter type is valid, it converts it to a valid key" do
      assert CacheKeyBuilder.convert(" nEw  city To sEArch  ") == "new_city_to_search"
    end
  end
end
