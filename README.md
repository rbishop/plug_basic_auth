# PlugBasicAuth

This is a Plug module for adding [HTTP Basic Authentication](http://tools.ietf.org/html/rfc2617) to a set of routes. Only basic authentication is currently supported.

## Installation

Add `plug_basic_auth` to the `deps` function in your project's `mix.exs` file:

```elixir
defp deps do
  [{:plug_basic_auth, "~> 1.1"}]
end
```
	
Then run `mix do deps.get, deps.compile` inside your project's directory.

## Usage

PlugBasicAuth can be used just as any other Plug. Add PlugBasicAuth before all of the other plugs you want to happen after successful authentication using the `plug` function.

```elixir
defmodule TopSecret do
  import Plug.Conn
  use Plug.Router

  plug PlugBasicAuth, validation: &TopSecret.is_authorized/2
  plug :match
  plug :dispatch

  get "/top_secret" do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, "Hello, Newman.")
  end

  def is_authorized("Wayne", "Knight"), do: :authorized
  def is_authorized(_user, _password), do: :unauthorized
end
```

#### The validation callback
The validation callback will be called to decide if the user is authorized or not.

* It has to be defined in the format `&Mod.fun/2`.

* It receives `username, password` and must return `:authorized` or `:unauthorized`

## License

PlugBasicAuth uses the same license as Plug and the Elixir programming language. See the [license file](https://raw.githubusercontent.com/rbishop/plug_basic_auth/master/LICENSE) for more information.
