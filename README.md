# companion-elixir

FFXIV Companion App lib for Elixir

```elixir
iex(1)> Companion.configure(uid: "9fdd8622-9d33-4ff9-9b11-2187519ebe9b")
:ok
iex(2)> Companion.Auth.request_token()
%{
  "region" => "",
  "salt" => "14e91d3fd18ff697a9c5d1a891599865204278b8",
  "token" => "31a804b46c05ff185c287f0969f41e1a"
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

