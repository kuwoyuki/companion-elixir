defmodule Companion.Auth do
  require Logger

  defstruct [
    :access_token,
    :scope,
    :expires_in,
    :associated_user_scope,
    :associated_user
  ]

  alias Companion.{Config}

  @pem "-----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAtDLA2/jQxScusojWLHyh
CYNW8S9yM+DuaLgiXZC/tk79H1u4jiip1kRx2zrQ9nvnMqYMNYarqKDlJmIL10B5
UWY+vDXdXXiXx5qQtj+NgPslhiZMDxpA0EfDvBdQ7Hmk/m1qocP0i0uYVzvyZBKW
N1Xj1QDuZzKfXP6rpfPVB1rSwxAMpEcyMHhtsTsEf+w9Sr+Wy/oJQau+k+rLhYtl
n+HsF9LCn5d1O4AuBFOHDh5gAitRjl2cp0hHYRYHQ0WAwYqeTqi+HW2XJAU/cCWX
F9LFjKH7Q6LBrcQzgbFsn1jwE4gKGl/DxZWFFLMYoUrHU5z/cGfVH8k6Lheu02b9
hQIDAQAB
-----END PUBLIC KEY-----"

  @platform %{
    :ios => 1,
    :android => 2
  }
  @app_version "1.5.1"
  @sqex_auth_uri "https://secure.square-enix.com/oauth/oa/oauthauth"
  @sqex_oauth_uri "https://secure.square-enix.com/oauth/oa/"
  @oauth_callback "https://companion.finalfantasyxiv.com/api/0/auth/callback"

  @spec rsa_encrypt(binary) :: binary
  def rsa_encrypt(str) do
    pub_key = X509.PublicKey.from_pem!(@pem)

    str
    |> :public_key.encrypt_public(pub_key)
    |> :base64.encode()
  end

  @spec refresh_token :: :ok
  def refresh_token do
    body = %{
      appVersion: @app_version,
      platform: @platform.android,
      uid: Config.get()[:uid]
    }

    %{"token" => token} = Companion.API.Base.request(:post, "login/token", body)
    Config.append(:token, token)
  end

  @spec build_login_uri(binary) :: binary
  def build_login_uri(uri) do
    @sqex_auth_uri <>
      "?" <>
      URI.encode_query(%{
        client_id: "ffxiv_comapp",
        response_type: "code",
        lang: "en-us",
        redirect_uri: uri
      })
  end

  @spec build_oauth_redirect(%{salt: any, token: any}) :: binary
  def build_oauth_redirect(res) do
    config = Config.get()

    uid =
      Plug.Crypto.KeyGenerator.generate(config[:user_id], res["salt"], digest: :sha, length: 128)
      |> Base.encode16()
      |> String.downcase()

    @oauth_callback <>
      "?" <>
      URI.encode_query(%{token: res["token"], uid: uid, request_id: config[:user_id], facflg: 1})
  end

  @doc """
  Get a new valid token + salt from SQEX
  POST("/login/token")
  """
  def request_salt_token(platform \\ @platform.android) do
    config = Config.get()

    body = %{
      appVersion: @app_version,
      platform: platform,
      uid: config[:user_id] |> rsa_encrypt()
    }

    Companion.API.Base.request(:post, "login/token", body)
  end

  # something strange with headers here
  @spec submit_form(binary, any, any) ::
          {:ok, HTTPoison.Response.t() | HTTPoison.AsyncResponse.t()}
          | {:error, HTTPoison.Error.t()}
  def submit_form(url, payload, headers \\ ["content-type": "application/x-www-form-urlencoded"]),
    do: HTTPoison.post(url, {:form, payload}, headers)

  @spec hidden_input_val(binary | [any] | tuple, any) :: [any]
  def hidden_input_val(el, n),
    do: el |> Floki.find("input[name=#{n}]") |> Floki.attribute("value")

  @spec request_token({:error, HTTPoison.Error.t()} | {:ok, HTTPoison.Response.t()}) ::
          {:error, any} | {:ok, [{:token, any} | {:uid, any}, ...]}
  def request_token(res) do
    case res do
      {:ok, %HTTPoison.Response{status_code: 302, headers: raw_headers}} ->
        # apparently you need to send the very last cookie with the form?
        headers = Enum.into(raw_headers, %{})

        form =
          HTTPoison.get!(
            headers["Location"],
            [
              Accept:
                "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3",
              "X-Requested-With": "com.square_enix.android_googleplay.ffxivcomapp_e"
            ],
            hackney: [cookie: String.split(headers["Set-Cookie"], ";") |> hd]
          ).body
          |> Floki.find("form")

        # TODO: refactor this
        [url] = form |> Floki.attribute("action")
        [cis_sessid] = form |> hidden_input_val("cis_sessid")
        [provision] = form |> hidden_input_val("provision")
        [c] = form |> hidden_input_val("_c")

        %{"token" => token, "uid" => uid} = URI.parse(url).query |> URI.decode_query()

        data = %{cis_sessid: cis_sessid, provision: provision, _c: c}
        post_data = URI.encode_query(data)

        case HTTPoison.post(url, post_data, "Content-Type": "application/x-www-form-urlencoded") do
          {:ok, %HTTPoison.Response{status_code: 202}} ->
            Logger.debug("got token: #{token}")
            {:ok, [{:token, token}, {:uid, uid}]}

          {:error, %HTTPoison.Error{reason: reason}} ->
            Logger.error(reason)
            {:error, reason}
        end

      {:ok, %HTTPoison.Response{status_code: status_code, body: body}} ->
        Logger.error("#{status_code}: #{body}")

      {:error, %HTTPoison.Error{reason: reason}} ->
        Logger.error(reason)
    end
  end

  @spec login_sight(binary, %{password: any, username: any}) ::
          {:error, any} | {:ok, [{:token, any} | {:uid, any}, ...]}
  def login_sight(url, creds) do
    case HTTPoison.get(url, [], follow_redirect: true) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        form = body |> Floki.find("#loginForm")
        [path] = form |> Floki.attribute("action")
        [token] = form |> Floki.find("input[type=hidden]") |> Floki.attribute("value")

        (@sqex_oauth_uri <> path)
        |> submit_form(
          _STORED_: token,
          sqexid: creds.username,
          password: creds.password
        )
        |> request_token()

      {:ok, %HTTPoison.Response{status_code: status_code, body: body}} ->
        Logger.error("#{status_code}: #{body}")

      {:error, %HTTPoison.Error{reason: reason}} ->
        Logger.error(reason)
    end
  end
end
