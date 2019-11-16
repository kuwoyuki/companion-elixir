defmodule Companion.Client do

  @moduledoc """
  `Client` represents an API Client.
  """

  import HTTPoison.Retry

  @spec set_request_id(keyword) :: any
  def set_request_id(opts) do
    cond do
      Keyword.has_key?(opts, :request_id) -> opts[:request_id]
      true -> :os.system_time(:second)
    end
  end

  @spec request(any, any, any, keyword) :: any
  def request(method, url, body, opts) do
    headers = [
      {"user-agent", "xivcompanion-EU/1.5.1 Device/1"},
      {"request-id", set_request_id(opts)},
      {"token", opts[:token]},
      {"content-type", "application/json;charset=utf-8"}
    ]

    case method do
      :get ->
        HTTPoison.get(url, headers)

      _ ->
        HTTPoison.request(
          method,
          url,
          Poison.encode!(body),
          headers
        )
    end
    |> autoretry(max_attempts: 5, wait: 1000, status_codes: [202])
    |> elem(1)
  end
end
