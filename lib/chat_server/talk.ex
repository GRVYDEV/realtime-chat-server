defmodule ChatServer.Talk do
  alias ChatServer.Repo
  alias ChatServer.Talk.Room
  alias ChatServer.Talk.Message
  import Ecto.Query

  def list_rooms() do
    Repo.all(Room)
  end

  def create_message(user, room, attrs \\ %{}) do
    Message.changeset(%Message{room_id: room.id, user: user.name}, attrs)
    |> Repo.insert()
  end

  def list_messages(room_id) do
    Repo.all(
      from msg in Message,
        where: msg.room_id == ^room_id,
        order_by: [desc: msg.inserted_at],
        select: %{body: msg.body, user: msg.user}
    )
  end

  def create_room(user, attrs \\ %{}) do
    user
    |> Ecto.build_assoc(:rooms)
    |> Room.changeset(attrs)
    |> Repo.insert()
  end

  def get_room!(id), do: Repo.get!(Room, id)

  def change_room(%Room{} = room) do
    Room.changeset(room, %{})
  end

  def update_room(%Room{} = room, attrs) do
    room
    |> Room.changeset(attrs)
    |> Repo.update()
  end

  def delete_room(%Room{} = room) do
    room
    |> Repo.delete()
  end
end
