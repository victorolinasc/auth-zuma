defmodule AuthZuma.UMAClient do
  @moduledoc """
  Main interface for calling out resource actions.
  """
  use Tesla, docs: false

  alias AuthZuma.Resource
  alias AuthZuma.Middleware, as: ZumaMiddleware
  alias Tesla.Middleware

  plug(
    Middleware.BaseUrl,
    Application.get_env(:auth_zuma, :iam_uma_base_url) <>
      Application.get_env(:auth_zuma, :resource_set_path)
  )

  plug(Middleware.Opts, authentication_module: Application.get_env(:auth_zuma, :auth_module))
  plug(ZumaMiddleware.Bearer)
  plug(ZumaMiddleware.Unauthenticated)
  plug(Middleware.JSON)
  plug(Middleware.Logger)

  def create_resource(res = %Resource{}) do
    wrap_response(fn -> post("/", Map.from_struct(res)) end, 201)
  end

  def list_resources() do
    wrap_response(fn -> get("/") end, 200)
  end

  def get_resource(resource_id) do
    wrap_response(fn -> get("/#{resource_id}") end, 200)
  end

  def update_resource(resource_id, res = %Resource{}) do
    wrap_response(fn -> put("/#{resource_id}", Map.from_struct(res)) end, 201)
  end

  def delete_resource(resource_id) do
    wrap_response(fn -> delete("/#{resource_id}") end, 200)
  end

  defp wrap_response(fun, expected_status) do
    with {:ok, resp} <- fun.(),
         ^expected_status <- resp.status do
      {:ok, resp.body}
    else
      401 ->
        {:error, :unauthenticated}

      403 ->
        {:error, :unauthorized}

      404 ->
        {:error, :not_found}

      status when is_integer(status) and status >= 400 and status < 500 ->
        {:error, :client_error}

      status when is_integer(status) and status >= 500 ->
        {:error, :server_error}

      err ->
        err
    end
  end
end
