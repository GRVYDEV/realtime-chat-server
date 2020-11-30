defmodule ChatServerWeb.RoomChannel do
  use ChatServerWeb, :channel

  alias ChatServer.Repo
  alias ChatServer.Accounts.User
  alias ChatServerWeb.Presence
  alias ChatServer.Talk.Message
  alias ChatServer.Talk

  def join("room:" <> room_id, _params, socket) do
    send(self(), :after_join)
    {:ok, %{messages: Talk.list_messages(room_id)}, assign(socket, :room_id, room_id)}
  end

  def handle_in("message:add", %{"message" => body}, socket) do
    room = Talk.get_room!(socket.assigns[:room_id])
    user = get_user(socket)

    case Talk.create_message(user, room, %{body: body}) do
      {:ok, message} ->
        message_template = %{body: message.body, user: message.user}
        broadcast!(socket, "room:#{room.id}:new_message", message_template)
        {:reply, :ok, socket}

      {:error, _} ->
        {:reply, :error, socket}
    end
  end

  def handle_in("user:typing", %{"typing" => typing, "token" => token}, socket) do
    user = get_user(socket)

    {:ok, _} =
      Presence.update(socket, "user:#{user.id}", %{
        typing: typing,
        typing_token: token,
        user_id: user.id,
        username: user.name
      })

    {:reply, :ok, socket}
  end

  def handle_info(:after_join, socket) do
    push(socket, "presence_state", Presence.list(socket))

    user = get_user(socket)

    {:ok, _} =
      Presence.track(socket, "user:#{user.id}", %{
        typing: false,
        typing_token: nil,
        user_id: user.id,
        username: user.name
      })

    {:noreply, socket}
  end

  def get_user(socket) do
    socket.assigns[:current_user_id]
  end
end
