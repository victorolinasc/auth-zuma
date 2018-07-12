defmodule AuthZuma.Resource do
  @moduledoc """
  Represents a resource on the authorization server.

  This has some fields specifically to Keycloak. 
  """

  @type resource_scope :: binary
  @type type :: binary
  @type uri :: binary | nil
  @type owner :: %{id: binary}

  @type t :: %__MODULE__{
          resource_scopes: [resource_scope],
          icon_uri: uri,
          name: binary,
          type: type,
          uri: uri,
          owner: owner,
          attributes: term,
          ownerManagedAccess: boolean
        }

  defstruct resource_scopes: [],
            icon_uri: nil,
            name: nil,
            type: nil,
            uri: nil,
            owner: nil,
            attributes: %{},
            ownerManagedAccess: false
end
