defmodule Companion.API.Base do
  @moduledoc """
  Provides basic and common functionalities for FFXIV Companion API.
  """

  alias Companion.Config

  @spec request(any, any, any, keyword) :: false | nil | true | binary | [any] | number | map
  def request(method, path, body \\ %{}, opts \\ []) do
    do_request(method, request_url(path), body, opts)
  end

  defp do_request(method, url, body, opts) do
    config = Companion.Config.get()

    case Companion.Client.request(method, url, body, opts ++ config) do
      %HTTPoison.Response{body: body, status_code: code} when code >= 200 and code < 300 ->
        Poison.decode!(body)

      %HTTPoison.Response{body: body, status_code: code} ->
        throw(%Companion.Error{code: code, message: body})

      %HTTPoison.Error{reason: message} ->
        throw(%Companion.ConnectionError{reason: message})
    end
  end

  def request_url(path) do
    config = Config.get()

    cond do
      Keyword.has_key?(Config.get(), :uri) -> config[:uri] <> "sight-v060/sight/#{path}"
      true -> "https://companion.finalfantasyxiv.com/sight-v060/sight/#{path}"
    end
  end
end
