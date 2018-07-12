defmodule AuthZuma.Application do
  @moduledoc false

  use Application

  @iam_uma_base_url "IAM_UMA_BASE_URL"
  @resource_set_path "RESOURCE_SET_PATH"
  @authenticate_path "AUTHENTICATE_PATH"
  @client_id "CLIENT_ID"
  @client_secret "CLIENT_SECRET"
  @joken_jwks_url "JOKEN_JWKS_URL"
  @joken_jwks_key_id "JOKEN_JWKS_KEY_ID"

  def start(_type, _args) do
    children = []

    init_config(Application.get_all_env(:auth_zuma))

    opts = [strategy: :one_for_one, name: AuthZuma.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp init_config(config) do
    if config[:load_from_system_env] do
      error_msg = &"expected the #{&1} environment variable to be set"

      # mandatory env vars
      iam_uma_base_url = System.get_env(@iam_uma_base_url) || raise error_msg.(@iam_uma_base_url)
      client_id = System.get_env(@client_id) || raise error_msg.(@client_id)
      client_secret = System.get_env(@client_secret) || raise error_msg.(@client_secret)

      joken_jwks_url = System.get_env(@joken_jwks_url) || iam_uma_base_url

      joken_jwks_key_id =
        System.get_env(@joken_jwks_key_id) || raise error_msg.(@joken_jwks_key_id)

      Application.put_env(:auth_zuma, :iam_uma_base_url, iam_uma_base_url)
      Application.put_env(:auth_zuma, :client_id, client_id)
      Application.put_env(:auth_zuma, :client_secret, client_secret)

      Application.put_env(:joken_jwks, :joken_jwks_url, joken_jwks_url)
      Application.put_env(:joken_jwks, :joken_jwks_key_id, joken_jwks_key_id)

      # optional paths
      resource_set_path = System.get_env(@resource_set_path) || config[:resource_set_path]
      authenticate_path = System.get_env(@authenticate_path) || config[:authenticate_path]

      Application.put_env(:auth_zuma, :resource_set_path, resource_set_path)
      Application.put_env(:auth_zuma, :authenticate_path, authenticate_path)
    end
  end
end
