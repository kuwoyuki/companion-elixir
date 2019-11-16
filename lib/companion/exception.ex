defmodule Companion.Error do
  defstruct code: nil, message: nil
  @type t :: %__MODULE__{}
end

defmodule Companion.ConnectionError do
  defstruct reason: nil, message: "Connection error."
  @type t :: %__MODULE__{}
end
