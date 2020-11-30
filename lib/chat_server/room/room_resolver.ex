defmodule ChatServer.Room.RoomResolver do
  alias ChatServer.Talk

  alias ChatServer.Accounts

  def all(_args, _info) do
    {:ok, Talk.list_rooms()}
  end

  def create(%{:name => name, :description => description, :topic => topic}, %{
        :context => %{:user_id => user_id}
      }) do
    user = Accounts.get_user!(user_id)

    case Talk.create_room(user, %{name: name, description: description, topic: topic}) do
      {:ok, room} -> {:ok, room}
      {:error, _changeset} -> {:error, "Something went wrong with your room"}
    end
  end
end
