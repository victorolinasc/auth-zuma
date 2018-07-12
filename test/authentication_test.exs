defmodule AuthZumaAuthenticationTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  test "can use client credentials to authenticate" do
    mock(fn
      %{
        method: :post,
        url: "http://localhost:8080/auth/realms/master/protocol/openid-connect/token/",
        headers: [
          {"content-type", "application/x-www-form-urlencoded"},
          {"authorization", "Basic " <> auth}
        ],
        body: "grant_type=client_credentials"
      } ->
        json(%{"access_token" => "some_token" <> auth})
    end)

    assert {:ok, "some_token" <> auth} = AuthZuma.Authentication.ClientCredentials.authenticate()
    assert Base.encode64("auth_zuma_test:auth_zuma_secret") == auth
  end

  @tag :capture_log
  test "fails for 401" do
    mock(fn
      %{
        method: :post,
        url: "http://localhost:8080/auth/realms/master/protocol/openid-connect/token/",
        headers: [
          {"content-type", "application/x-www-form-urlencoded"},
          {"authorization", "Basic " <> _auth}
        ],
        body: "grant_type=client_credentials"
      } ->
        json(%{"error" => "unauthenticated"}, status: 401)
    end)

    assert {:error, :unauthenticated} == AuthZuma.Authentication.ClientCredentials.authenticate()
  end

  @tag :capture_log
  test "fails for 403" do
    mock(fn
      %{
        method: :post,
        url: "http://localhost:8080/auth/realms/master/protocol/openid-connect/token/",
        headers: [
          {"content-type", "application/x-www-form-urlencoded"},
          {"authorization", "Basic " <> _auth}
        ],
        body: "grant_type=client_credentials"
      } ->
        json(%{"error" => "unauthorized"}, status: 403)
    end)

    assert {:error, :unauthorized} == AuthZuma.Authentication.ClientCredentials.authenticate()
  end

  @tag :capture_log
  test "fails for 500" do
    mock(fn
      %{
        method: :post,
        url: "http://localhost:8080/auth/realms/master/protocol/openid-connect/token/",
        headers: [
          {"content-type", "application/x-www-form-urlencoded"},
          {"authorization", "Basic " <> _auth}
        ],
        body: "grant_type=client_credentials"
      } ->
        %Tesla.Env{status: 503}
    end)

    assert {:error, :server_error} == AuthZuma.Authentication.ClientCredentials.authenticate()
  end
end
