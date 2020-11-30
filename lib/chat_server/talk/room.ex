defmodule ChatServer.Talk.Room do
  use Ecto.Schema
  import Ecto.Changeset
  alias ChatServer.Talk.Room
  alias ChatServer.Repo

  schema "rooms" do
    field :name, :string

    has_many :messages, ChatServer.Talk.Message

    timestamps()
  end

  @doc false
  def changeset(%Room{} = room, attrs) do
    room
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
    |> validate_length(:name, min: 1, max: 30)
    |> validate_length(:topic, min: 1, max: 120)
  end

  def data() do
    Dataloader.Ecto.new(ChatServer.Repo, query: &query/2)
  end

  def query(Room, _params) do
    Repo.all(Room)
    |> Repo.preload(:messages)
  end

  def query(queryable, _params), do: queryable
end
