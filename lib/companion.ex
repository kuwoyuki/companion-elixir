defmodule Companion do
  @moduledoc """
  Documentation for FFXIV Companion API client.
  """

  @doc """
  Auth configuration settings
  ## Examples
      Companion.configure(
        uid: "2b0be7f8-5cac-4cae-9754-36dc1dbc0449"
        token: "Sight token",
      )
  """

  @spec configure(Keyword.t()) :: :ok
  defdelegate configure(config), to: Companion.Config, as: :set
end
