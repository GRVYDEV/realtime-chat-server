defmodule ChatServer.Repo.Migrations.AddMessagesAndRooms do
  use Ecto.Migration

  def change do
    create table(:rooms) do
      add :name, :string

      timestamps
    end

    create table(:messages) do
      add :body, :string
      add :user, :string
      add :room_id, references(:rooms, on_delete: :delete_all)

      timestamps
    end
  end
end
