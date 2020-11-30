defmodule ChatServer.Repo do
  use Ecto.Repo,
    otp_app: :chat_server,
    adapter: Ecto.Adapters.Postgres
end
