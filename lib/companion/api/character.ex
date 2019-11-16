defmodule Companion.API.Character do
  alias Companion.API

  @doc """
  Get the current character's world
  """
  @spec character_worlds :: false | nil | true | binary | [any] | number | map
  def character_worlds do
    API.Base.request(:get, "character/worlds")
  end
end
