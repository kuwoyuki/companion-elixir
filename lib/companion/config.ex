defmodule Companion.Config do
  @spec get :: any
  def get, do: Process.get(:_companion_config, [])

  @spec set(any) :: :ok
  def set(value) do
    Process.put(:_companion_config, value)
    :ok
  end

  @spec append(any, any) :: any
  def append(k, v), do: Process.put(:_companion_config, Keyword.put(get(), k, v)) # wat
  :ok
end
