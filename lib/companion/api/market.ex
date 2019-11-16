defmodule Companion.API.Market do
  alias Companion.API

  @doc """
  Market search using item ID and world name, currently it's optional
  and can only be the currently active world
  """
  @spec market_search(binary, binary) :: false | nil | true | binary | [any] | number | map
  def market_search(id, world) do
    API.Base.request(:get, "market/items/catalog/#{id}?worldName=#{world}")
  end
end
