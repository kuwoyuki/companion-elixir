defmodule Companion.API.Login do
  alias Companion.{Config, API}

  @spec region :: false | nil | true | binary | [any] | number | map
  def region do
    API.Base.request(:get, "login/region")
  end

  @spec characters :: false | nil | true | binary | [any] | number | map
  def characters do
    API.Base.request(:get, "login/characters")
  end

  @spec login_character(binary) :: false | nil | true | binary | [any] | number | map
  def login_character(id) do
    res = API.Base.request(:post, "login/characters/" <> id, %{appLocaleType: "EU"})
    Config.append(:uri, res["region"])
    res
  end

  def set_fcm_token(token) do
    API.Base.request(:post, "login/fcm-token", %{fcmToken: token})
  end
end
