defmodule MyCoolApp do
  import Plug.Conn
  use Plug.Router

  plug Plug.BasicAuth, [username: "", password: ""]
  plug :match
  plug :dispatch

  get "/top_secret" do
    conn |>
    put_resp_header("www-authenticate", "Basic realm=\"insert realm\"")
    send_resp(conn, 401, "Access granted")
  end
end

IO.puts "Running MyCoolApp with Cowboy on port 3000. Yee-haw!"
Plug.Adapters.Cowboy.http MyCoolApp, [], [{:port, 3000}]
