defmodule Weather.CacheTest do
  use Weather.DataCase, async: true

  alias Weather.Cache

  describe "#start" do
    test "when the second call handles an ArgumentError with cache already running" do
      assert Cache.start() == {:error, :already_started}
    end
  end

  describe "#get" do
    test "when the key is not defined" do
      refute Cache.get(:undefined_key)
    end

    test "when the key value has been stored previously" do
      :ok = Cache.put(:key, "value")

      assert Cache.get(:key) == "value"
    end
  end

  test "#put" do
    assert Cache.put(:key, "value") == :ok
  end

  test "#delete" do
    assert Cache.delete(:key) == :ok
  end

  describe "#resolve" do
    test "when the key is not defined, it defines and saves the data" do
      assert Cache.resolve(:key, fn -> "value" end) == {:ok, "value"}
    end

    test "when the key value has been stored previously, returns it" do
      :ok = Cache.put(:key, "value")

      assert Cache.resolve(:key, fn -> "value" end) == {:ok, "value"}
    end
  end

  describe "#string_to_atom_key" do
    test "when param is not a binary type" do
      assert_raise FunctionClauseError, fn ->
        Cache.string_to_atom_key(1)
      end
    end

    test "when the parameter type is valid, it converts it to an atom key" do
      assert Cache.string_to_atom_key(" nEw  city To sEArch  ") == :new_city_to_search
    end
  end
end
