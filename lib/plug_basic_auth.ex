defmodule Plug.BasicAuth do
  @moduledoc """
  A plug for protecting routers with HTTP Basic Auth.

  It expects a `:username` and `:password` to be passed as
  binaries at initialization.

  The user will be prompted for a username and password upon
  accessing any of the routes using this plug. 

  If the username and password are correct, the user will be 
  able to access the page.

  If the username and password are incorrect, the user will be 
  prompted to enter them again.

  ## Example

      defmodule TopSecret do
        import Plug.Conn
        use Plug.Router

        plug Plug.BasicAuth, username: "Snorky", password: "Capone"
        plug :match
        plug :dispatch

        get '/speakeasy' do
          conn
          |> put_resp_content_type("text/plain")
          |> send_resp(200, "Welcome to the party.")
        end
      end
  """
  @behaviour Plug.Wrapper

  import Plug.Conn, only: [get_req_header:  2,
                           put_resp_header: 3,
                           send_resp:       3]

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
