defmodule ChatServer.User.UserResolver do
  alias ChatServer.Accounts
  alias ChatServer.Accounts.User

  def all(_args, _info) do
    {:ok, Accounts.list_users()}
  end

  def find_user(_parent, %{id: id}, _resolution) do
    case Accounts.get_user!(id) do
      nil -> {:error, "User ID #{id} not found"}
      user -> {:ok, user}
    end
  end

  def create(params, _info) do
    case Accounts.create_user(params) do
      {:ok, user} ->
        with {:ok, jwt, _} <- Guardian.encode_and_sign(Chat.Guardian, user) do
          {:ok, %{token: jwt}}
        end

      {:error, changeset} ->
        {:error, changeset}
    end
  end
end
