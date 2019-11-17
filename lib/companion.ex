defmodule Companion do
  alias Companion.{Auth, API, Config}

  @moduledoc """
  Documentation for FFXIV Companion API client.
  """

  @doc """
  Auth configuration settings
  ## Examples
      Companion.configure(
        user_id: "2b0be7f8-5cac-4cae-9754-36dc1dbc0449"
        token: "Sight token",
      )
  """

  @spec configure(Keyword.t()) :: :ok
  defdelegate configure(config), to: Config, as: :set

  @spec configure_random_uid :: :ok
  def configure_random_uid() do
    Config.set(user_id: UUID.uuid4())
    :ok
  end

  @spec login(%{password: any, username: any}) :: {:ok, [{:token, any} | {:uid, any}, ...]}
  def login(creds) do
    {:ok, details} =
      Auth.request_salt_token()
      |> Auth.build_oauth_redirect()
      |> Auth.build_login_uri()
      |> Auth.login_sight(creds)

    Config.set(Config.get() ++ details)
    config = Enum.into(Config.get(), %{})

    API.Base.request(
      :post,
      "login/auth?" <>
        URI.encode_query(%{
          token: config[:token],
          uid: config[:uid],
          "request-id": config[:user_id]
        }),
      %{},
      request_id: config[:user_id]
    )

    {:ok, details}
  end

  defdelegate region, to: Companion.API.Login

  defdelegate character, to: Companion.API.Login

  defdelegate characters, to: Companion.API.Login

  defdelegate login_character(id), to: Companion.API.Login

  defdelegate set_fcm_token(token), to: Companion.API.Login

  defdelegate character_worlds, to: Companion.API.Character

  defdelegate market_search(id, world), to: Companion.API.Market
end
