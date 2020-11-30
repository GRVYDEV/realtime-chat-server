defmodule ChatServer.Session.SessionResolver do
  alias ChatServer.Accounts

  @spec new(%{email: any, password: any}, any) :: {:error, <<_::224>>} | {:ok, %{token: binary}}
  def new(%{:email => email, :password => password}, _info) do
    with {:ok, user} <- Accounts.sign_in(email, password),
         {:ok, jwt, _} <- ChatServer.Guardian.encode_and_sign(user) do
      {:ok, %{token: jwt}}
    else
      _ -> {:error, "Issue with email or password"}
    end
  end
end
