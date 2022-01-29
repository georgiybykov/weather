defmodule Weather.CacheTest do
  use Weather.DataCase, async: true

  alias Weather.Cache

  describe "#fetch/2" do
    test "when the key is not defined, it defines and saves the data" do
      assert Cache.fetch(:key, fn -> "value" end) == {:ok, "value"}
    end

    test "when the key value has been stored previously, returns it" do
      :ok = Cache.put(:key, "value")

      assert Cache.fetch(:key, fn -> "value" end) == {:ok, "value"}
    end
  end

  describe "#get/2" do
    test "when the key is not defined" do
      refute Cache.get(:undefined_key)
    end

    test "when the key value has been stored previously" do
      :ok = Cache.put(:key, "value")

      assert Cache.get(:key) == "value"
    end
  end

  test "#put/2" do
    assert Cache.put(:key, "value") == :ok
  end

  test "#delete/1" do
    assert Cache.delete(:key) == :ok
  end
end
