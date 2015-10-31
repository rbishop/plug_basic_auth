defmodule PlugBasicAuth do
  @moduledoc """
  A plug for protecting routers with HTTP Basic Auth.

  It expects a :validation to be passed as &Mod.fun/2 at initialization.

  The user will be prompted for a username and password upon
  accessing any of the routes using this plug.

  The :validation callback would be used to decide if the username and
  password are correct:

  If it returns :authorized, the username and password are correct
  and the user will be able to access the page.

  If it returns :unauthorized, the username and password are incorrect
  and the user will be prompted to enter them again.

  ## Example

      defmodule TopSecret do
        import Plug.Conn
        use Plug.Router
        plug PlugBasicAuth, validation: &TopSecret.is_authorized/2
        plug :match
        plug :dispatch

        get '/speakeasy' do
          conn
          |> put_resp_content_type("text/plain")
          |> send_resp(200, "Welcome to the party.")
        end

        def is_authorized("Snorky", "Capone"), do: :authorized
        def is_authorized(user, pwd), do: :unauthorized
      end
  """

  import Plug.Conn, only: [get_req_header:  2,
                           put_resp_header: 3,
                           send_resp:       3,
                           halt:            1]

  def init(opts) do
    case Keyword.fetch(opts, :validation) do
      {:ok, validation} ->
        validation
      :error ->
        raise_undefined_validation_error(opts)
    end
  end

  def call(conn, validation) do
    {user, pwd} = get_credentials(conn)
    auth_response = validation.(user, pwd)
    respond(conn, auth_response)
  end

  defp get_credentials(conn) do
    conn
    |> get_auth_header
    |> parse_auth
  end

  defp get_auth_header(conn) do
    get_req_header(conn, "authorization")
  end

  defp parse_auth(["Basic " <> encoded_creds | _]) do
    {:ok, decoded_creds} = Base.decode64(encoded_creds)
    [user, pwd] = String.split(decoded_creds, ":", parts: 2)
    {user, pwd}
  end
  defp parse_auth(_), do: {nil, nil}

  defp respond(conn, :authorized), do: conn
  defp respond(conn, :unauthorized) do
    conn
    |> put_resp_header("www-authenticate", "Basic realm=\"Private Area\"")
    |> send_resp(401, "")
    |> halt
  end

  defp raise_undefined_validation_error(opts) do
    if Keyword.has_key?(opts, :username) do
      raise ":username and :password options are no longer supported. Use the :validation option with a function that takes two arguments"
    else
      raise ":validation option is not defined"
    end
  end
end
