defmodule Secret do
  import Plug.Conn
  use Plug.Router

  plug PlugBasicAuth, username: "Wayne", password: "Knight"
  plug :match
  plug :dispatch

  get "/" do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, "Hello, Newman.")
  end
end

IO.puts "Running Secret via Cowboy on port 3000. Yee-haw!"
Plug.Adapters.Cowboy.http Secret, [], [{:port, 3000}]
