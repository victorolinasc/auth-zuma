defmodule AuthZuma.Middleware.Unauthenticated do
  @moduledoc """
  Tries authentication when receiving a 401 or 403.
  """

  @behaviour Tesla.Middleware

  @impl true
  def call(env, next, _options) do
    {:ok, env} = Tesla.run(env, next)

    case {env.status, env.opts[:authentication_module]} do
      {status, mod} when status in [403, 401] and not is_nil(mod) ->
        {:ok, token} = mod.authenticate()
        headers = Enum.filter(env.headers, &(elem(&1, 0) != "Authorization"))
        env = %{env | body: nil}

        %{env | headers: [{"Authorization", "Bearer #{token}"} | headers]}
        |> Tesla.run(next)

      _ ->
        {:ok, env}
    end
  end
end
