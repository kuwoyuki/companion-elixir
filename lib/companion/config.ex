defmodule Companion.Config do
  @doc """
  Get Companion configuration values.
  """
  def get, do: Process.get(:_companion_config, nil)

  @doc """
  Set Companion configuration values.
  """
  def set(value) do
    Process.put(:_companion_config, value)
    :ok
  end
end
