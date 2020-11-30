defmodule ChatServer.Guardian do
  use Guardian, otp_app: :chat_server
  alias ChatServer.Accounts

  def subject_for_token(resource, _claims) do
    sub = to_string(resource.id)
    {:ok, sub}
  end

  def subject_for_token(_, _) do
    {:error, :reason_for_error}
  end

  def resource_from_claims(claims) do
    id = claims["sub"]
    case Accounts.get_user!(id) do
      {:ok, user} -> {:ok, user}
      nil -> {:error, "User ID #{id} not found"}
    end
  end
end
