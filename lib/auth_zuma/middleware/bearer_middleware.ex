defmodule AuthZuma.Middleware.Bearer do
  @moduledoc """
  Uses the `authentication_module` option for fetching the access_token
  from the response.
  """

  @behaviour Tesla.Middleware

  @impl true
  def call(env, next, _options) do
    {:ok, token} = env.opts[:authentication_module].authenticate()

    %{env | headers: [{"Authorization", "Bearer #{token}"} | env.headers]}
    |> Tesla.run(next)
  end
end
