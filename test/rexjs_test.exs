defmodule Orisons.RexJSTest do
  use ExUnit.Case, async: false
  doctest Orisons.RexJS

  test "start worker" do
    assert {:ok, _} = Orisons.RexJS.Module.start_worker("public")
  end

  test "set data" do
    assert :ok = Orisons.RexJS.Module.set_data("public", "test", {:ok})
  end

  test "get data" do
    assert {:ok} = Orisons.RexJS.Module.get_data("public", "test")
  end
end
