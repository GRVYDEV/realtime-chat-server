defmodule ChatServer.Accounts do
  alias ChatServer.Repo
  alias ChatServer.Accounts.User

  def sign_in(email, password) do
    user = Repo.get_by(User, email: email)

    case Bcrypt.check_pass(user, password) do
      {:ok, user} ->
        {:ok, user}

      _ ->
        {:error, :unauthorized}
    end
  end

  def get_user!(id), do: Repo.get!(User, id)

  def list_users() do
    Repo.all(User)
  end

  def user_signed_in?(conn), do: !!current_user(conn)

  def current_user(conn) do
    user_id = Plug.Conn.get_session(conn, :current_user_id)

    if user_id, do: Repo.get(User, user_id)
  end

  def sign_out(conn, _) do
    Plug.Conn.configure_session(conn, drop: true)
  end

  def register(params) do
    User.registration_changeset(%User{}, params)
    |> Repo.insert()
  end

  def update_user(%User{} = user, attrs) do
    user
    |> User.registration_changeset(attrs)
    |> Repo.update()
  end

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert()
  end

  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end
end
