defmodule AuthZuma.Authentication do
  @moduledoc """
  Behaviour for authenticating a client application with an authentication server.

  Per OAuth 2.0 we can authenticate with:

    - Client Credentials: client id + client secret
    - Bearer token: a JWT signed with the key registered for this client
  """

  @callback authenticate() :: {:ok, binary} | {:error, atom}
end
