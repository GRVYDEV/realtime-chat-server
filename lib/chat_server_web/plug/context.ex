defmodule ChatServerWeb.Plug.Context do
  @behaviour Plug
  import Plug.Conn
  alias Chat.Accounts

  def init(opts), do: opts

  def call(conn, _) do
    case build_context(conn) do
      {:ok, context} ->
        put_private(conn, :absinthe, %{context: context})

      {:error, _reason} ->
        conn


      _ ->
        conn
        |> send_resp(400, "Bad Request")
        |> halt()
    end
  end

  def build_context(conn) do
    with ["Bearer " <> auth_token] <- get_req_header(conn, "authorization"),
         {:ok, user_id} <- authorize(auth_token) do
      {:ok, %{user_id: user_id}}
    else
      [] -> {:ok, %{}}
      error -> error
    end
  end

  def authorize(auth_token) do
    case Guardian.decode_and_verify(Chat.Guardian, auth_token) do
      {:ok, claims} ->
        case Accounts.get_user!(claims["sub"]) do
          user -> {:ok, user.id}
          _ -> {:error, "No user found"}
        end

      {:error, _} ->
        {:error, "Invalid Auth Token"}
    end
  end
end
