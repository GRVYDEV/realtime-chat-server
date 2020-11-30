defmodule ChatServer.Talk.Message do
  use Ecto.Schema
  import Ecto.Changeset

  schema "messages" do
    field(:body, :string)
    field(:user, :string)
    belongs_to(:room, Chat.Talk.Room)

    timestamps()
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:body])
    |> validate_required([:body])
  end
end
