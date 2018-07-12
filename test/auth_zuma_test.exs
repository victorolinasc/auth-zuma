defmodule AuthZumaTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  test "can authenticate before request" do
    mock(fn
      # Request 2
      %{
        method: :get,
        url: "http://localhost:8080/auth/realms/master/authz/protection/resource_set/",
        headers: [{"Authorization", "Bearer some_token" <> base64_from_previous_request}]
      } ->
        json(["id1", "id2", base64_from_previous_request])

      # Request 1
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

    assert {:ok, ["id1", "id2", base64]} = AuthZuma.UMAClient.list_resources()
    assert Base.encode64("auth_zuma_test:auth_zuma_secret") == base64
  end

  @tag :capture_log
  test "does not loop on 401" do
    mock(fn
      # Request 2 and 4
      %{
        method: :get,
        url: "http://localhost:8080/auth/realms/master/authz/protection/resource_set/",
        headers: [{"Authorization", "Bearer some_token"}]
      } ->
        %Tesla.Env{status: 401}

      # Request 1 and 3
      %{
        method: :post,
        url: "http://localhost:8080/auth/realms/master/protocol/openid-connect/token/",
        headers: [
          {"content-type", "application/x-www-form-urlencoded"},
          {"authorization", "Basic " <> _auth}
        ],
        body: "grant_type=client_credentials"
      } ->
        json(%{"access_token" => "some_token"})
    end)

    assert {:error, :unauthenticated} == AuthZuma.UMAClient.list_resources()
  end
end
