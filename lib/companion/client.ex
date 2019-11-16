defmodule Companion.Client do
  require IEx

  @moduledoc """
  `Client` represents an API Client.
  """

  import HTTPoison.Retry

  @doc """
  Send a request
  """
  def request(method, url, body, token, _opts \\ []) do
    headers = [
      {"user-agent", "xivcompanion-EU/1.5.1 Device/1"},
      {"request-id", :os.system_time(:second)},
      {"token", token},
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
