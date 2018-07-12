use Mix.Config

config :auth_zuma,
  resource_set_path: "authz/protection/resource_set",
  authenticate_path: "protocol/openid-connect/token",
  auth_module: AuthZuma.Authentication.ClientCredentials,
  load_from_system_env: false
