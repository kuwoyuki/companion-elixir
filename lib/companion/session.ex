defmodule Companion.Session do
  @moduledoc false

  alias Companion.{Config, Session}

  defstruct [
    :type,
    :token,
    :request_id,
    :api_version,
    :req_opts
  ]

  @type t :: %__MODULE__{
          type: :basic | :oauth,
          token: binary() | nil,
          request_id: binary() | nil,
          api_version: binary() | nil,
          req_opts: Keyword.t() | nil
        }

  @spec new(binary) :: Companion.Session.t()
  def new(token) do
    %Session{
      type: :basic,
      token: token,
      request_id: "test",
      # api_version: Config.get(:api_version)
    }
  end
end
