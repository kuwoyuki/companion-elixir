defmodule Companion.Config do
  @spec get :: any
  def get, do: Application.get_env(:companion_ex, :config, [])

  @spec set(any) :: :ok
  def set(value) do
    Application.put_env(:companion_ex, :config, value)
    :ok
  end

  @spec append(any, any) :: any
  # wat
  def append(k, v), do: Application.put_env(:companion_ex, :config, Keyword.put(get(), k, v))
  :ok
end
