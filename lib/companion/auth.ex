defmodule Companion.Auth do
  require IEx

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

  @doc """
  Get a new valid token + salt from SQEX
  POST("/login/token")
  """
  def request_token(platform \\ @platform.android) do
    config = Config.get()
    pub_key = X509.PublicKey.from_pem!(@pem)

    hashed_uid =
      config[:uid]
      |> :public_key.encrypt_public(pub_key)
      |> :base64.encode()

    body = %{
      appVersion: @app_version,
      platform: platform,
      uid: hashed_uid
    }

    Companion.API.Base.request(:post, "login/token", body)
  end
end
