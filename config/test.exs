use Mix.Config

config :logger, level: :warn

config :tesla, adapter: Tesla.Mock

config :auth_zuma,
  iam_uma_base_url: "http://localhost:8080/auth/realms/master/",
  resource_set_path: "authz/protection/resource_set",
  authenticate_path: "protocol/openid-connect/token",
  client_id: "auth_zuma_test",
  client_secret: "auth_zuma_secret",
  auth_module: AuthZuma.Authentication.ClientCredentials,
  joken_jwks_url: "http://localhost:8080/auth/realms/master/protocol/openid-connect/certs",
  joken_jwks_key_id: "yIKgOoXqT-PwK9FYla2ZruMsUAuvqBzfglkOjqU_XHI",
  load_from_system_env: false
