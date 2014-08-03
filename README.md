# Plug.BasicAuth

This is a Plug module for adding [HTTP Basic Authentication](http://tools.ietf.org/html/rfc2617) to a set of routes. Only basic authentication is currently supported.

## Installation

Add `plug_basic_auth` to the `deps` function in your project's `mix.exs` file:

```elixir
defp deps do
  [{:plug_basic_auth, "~> 0.1.0"}]
end
```
	
Then run `mix do deps.get, deps.compile` inside your project's directory.

## Usage

Plug.BasicAuth can be used just as any other Plug. Add Plug.BasicAuth before all of the other plugs you want to happen after successful authentication using the `plug` function.

```elixir
defmodule TopSecret do
  import Plug.Conn
  use Plug.Router
  
  plug Plug.BasicAuth, username: "Wayne", password: "Knight"
  plug :match
  plug :dispatch
  
  get "/top_secret" do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, "Hello, Newman.")
  end
end
```

## Todo

* Enable adding authentication on a per route basis, instead of per router
* Add support for Digest Authentication

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

Plug.BasicAuth uses the same license as Plug and the Elixir programming language. See the [license file](https://raw.githubusercontent.com/rbishop/plug-basic_auth/master/LICENSE) for more information.