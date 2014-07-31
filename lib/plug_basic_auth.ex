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

  def wrap(conn, server_credentials, plug_stack) do
    authorization = get_req_header(conn, "authorization")
    case authorization do
      [] ->
        respond_with_login(conn)
      [auth | _] ->
        ["Basic", encoded_credentials] = String.split(auth, " ")
        {:ok, decoded_credentials}     = Base.decode64(encoded_credentials)
        if decoded_credentials == server_credentials do
          plug_stack.(conn)
        else
          respond_with_login(conn)
        end
    end
  end

  defp respond_with_login(conn) do
    conn
    |> put_resp_header("www-authenticate", "Basic realm =\"Private Area\"")
    |> send_resp(401, "")
  end
end
