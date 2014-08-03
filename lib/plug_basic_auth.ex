defmodule Plug.BasicAuth do
  import Plug.Conn, only: [get_req_header:  2,
                           put_resp_header: 3,
                           send_resp:       3]

  @behaviour Plug.Wrapper

  def init(opts) do
    username = Keyword.fetch!(opts, :username)
    password = Keyword.fetch!(opts, :password)
    username <> ":" <> password
  end

  def wrap(conn, server_creds, plug_stack) do
    case get_req_header(conn, "authorization") do
      [] ->
        respond_with_login(conn)
      ["Basic " <> encoded_creds | _] ->
        {:ok, decoded_creds} = Base.decode64(encoded_creds)
        if decoded_creds == server_creds do
          plug_stack.(conn)
        else
          respond_with_login(conn)
        end
    end
  end

  defp respond_with_login(conn) do
    conn
    |> put_resp_header("Www-Authenticate", "Basic realm =\"Private Area\"")
    |> send_resp(401, "")
  end
end
