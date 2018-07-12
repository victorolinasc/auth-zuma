defmodule AuthZuma.Authentication.ClientCredentials do
  @moduledoc """
  Client credentials strategy for authenticating the resource server.
  """
  use Tesla, docs: false

  alias Tesla.Middleware

  @behaviour AuthZuma.Authentication

  plug(
    Middleware.BaseUrl,
    Application.get_env(:auth_zuma, :iam_uma_base_url) <>
      Application.get_env(:auth_zuma, :authenticate_path)
  )

  plug(Middleware.BasicAuth, %{
    username: Application.get_env(:auth_zuma, :client_id),
    password: Application.get_env(:auth_zuma, :client_secret)
  })

  plug(Middleware.JSON)
  plug(Middleware.Logger)
  plug(Middleware.Retry)

  @impl true
  def authenticate do
    result =
      Tesla.build_client([
        {Middleware.FormUrlencoded, []}
      ])
      |> post("/", %{grant_type: "client_credentials"})

    with {:ok, %Tesla.Env{} = resp} <- result,
         200 <- resp.status do
      {:ok, resp.body["access_token"]}
    else
      401 ->
        {:error, :unauthenticated}

      403 ->
        {:error, :unauthorized}

      status when is_integer(status) and status >= 400 and status < 500 ->
        {:error, :client_error}

      status when is_integer(status) and status >= 500 ->
        {:error, :server_error}
    end
  end
end
