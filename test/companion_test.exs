defmodule CompanionTest do
  use ExUnit.Case
  doctest Companion

  test "greets the world" do
    assert Companion.hello() == :world
  end
end
