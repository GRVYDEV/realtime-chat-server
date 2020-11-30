defmodule ChatServerWeb.Schema.Types do
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers, only: [dataloader: 1]
  alias ChatServer.Talk.Room, as: Room

  object :user do
    field(:id, :id)
    field(:username, :string)
    field(:email, :string)
    field(:password_hash, :string)
  end

  object :session do
    field(:token, :string)
  end

  object :room do
    field(:id, :id)
    field(:description, :string)
    field(:name, :string)
    field(:topic, :string)
    field(:messages, list_of(:message), resolve: dataloader(Room))
  end

  object :message do
    field(:body, :string)
    field(:user, :string)
  end
end
