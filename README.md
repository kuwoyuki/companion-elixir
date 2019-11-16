# companion-elixir

FFXIV Companion App lib for Elixir

```elixir
# set random UUID or set your own using Companion.configure/1
iex(1)> Companion.configure_random_uid
:ok

# login using username/pass (doesn't handle OTP tokens cause im lazy)
iex(2)> Companion.login %{username: "thicc", password: "pass"}

23:45:38.365 [debug] got token: b88721d5e22c9c687b0e98bc9cb534a0
{:ok,
 [
   token: "b88721d5e22c9c687b0e98bc9cb534a0",
   uid: "efe55ea8c251c2bbb4e7f882956b82de0dd9508064e4e0f444ba923c24b3793265c24cc19d0c7cbf81051cba3bc1acb121fc80dba3112149363eb7df2f667df1cf8e7e4eab6afa47c0c9f890a1aed981fcdd3ab5462e188fe511a25cd793b605a9fcc308170d7bcaf486c696d57d413d021be2180fc99eb9f20f2f0e9400e335"
 ]}

# region
iex(3)> Companion.region
%{"region" => ""}

# your characters
iex(4)> Companion.characters
%{
  "accounts" => [
    %{
      "accName" => "FINAL FANTASY XIV",
      "characters" => [
        %{
          "bodyUrl" => "https://img2.finalfantasyxiv.com/f/.jpg",
          "cid" => "000fffffffffffff_12345",
          "faceUrl" => "https://img2.finalfantasyxiv.com/f/.jpg",
          "isRenamed" => false,
          "lodestonecid" => "123123",
          "name" => "Someone Cute",
          "status" => 1,
          "world" => "Twintania"
        },
  #...
      ]
    }
  ]
}
iex(5)> Companion.login_character("000fffffffffffff_12345")
%{"region" => "https://companion-eu.finalfantasyxiv.com/"}

# character info
iex(6)> Companion.API.Base.request(:get, "login/character")
%{
  "character" => %{
    "cid" => "85e39b75d6cb2198_24169",
    "lodestonecid" => "27982574",
    "name" => "Miko Kuri",
    "portrait" => "3533de29710b750a2776ffd07275a5b4_644311b63b607133c989d7c1188467da",
    "world" => "Odin"
  },
  "domains" => %{
    "appWeb" => "https://companion-app.finalfantasyxiv.com/",
    "cdn1" => "https://img.finalfantasyxiv.com/",
    "cdn2" => "https://img2.finalfantasyxiv.com/",
    "lodestone" => "https://{lang.lodestone}.finalfantasyxiv.com/"
  },
  "role" => 1,
  "updatedAt" => 1573944424850
}

# current char world
iex(7)> Companion.character_worlds
%{
  "currentWorld" => "Odin",
  "getBagFlag" => true,
  "loginStatusCode" => 0,
  "world" => "Odin"
}

# yeet.
iex(8)> Companion.market_search("27938", "Odin")
%{
  "entries" => [
    %{
      "catalogId" => 27938,
      "hq" => 1,
      "isCrafted" => true,
      "itemId" => "",
      "materia" => [],
      "materias" => 0,
      "registerTown" => 1,
      "sellPrice" => "999999999999",
      "sellRetainerName" => "Slave",
      "signatureName" => "Epic Crafter",
      "stack" => 1,
      "stain" => 0
    }
  ]
  # ...
}

# TODO
```

## Installation *future™*

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `companion` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:companion, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/companion](https://hexdocs.pm/companion).

