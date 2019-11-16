defmodule Companion.API.Base do
  @moduledoc """
  Provides basic and common functionalities for FFXIV Companion API.
  """

  @doc """
  Send request to the companion.finalfantasyxiv.com server.
  """
  def request(method, path, body \\ %{}) do
    do_request(method, request_url(path), body)
  end

  defp do_request(method, url, body) do
    config = Companion.Config.get()

    case Companion.Client.request(method, url, body, config[:token]) do
      %HTTPoison.Response{body: body, status_code: code} when code >= 200 and code < 300 ->
        Poison.decode!(body)

      %HTTPoison.Response{body: body, status_code: code} ->
        throw(%Companion.Error{code: code, message: body})

      %HTTPoison.Error{reason: message} ->
        throw(%Companion.ConnectionError{reason: message})
    end
  end

  def request_url(path) do
    "https://companion.finalfantasyxiv.com/sight-v060/sight/#{path}"
  end
end
