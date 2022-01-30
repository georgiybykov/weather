defmodule WeatherWeb.WeatherController do
  use WeatherWeb, :controller

  alias Weather.Cache

  @api_client Application.compile_env!(:weather, :weather_api_client)
  @ttl_sec 1800

  @type conn() :: Plug.Conn.t()
  @type search_map() :: %{binary() => binary()}

  @spec index(conn(), any()) :: conn()
  def index(conn, _params) do
    render(conn, "index.html", data: nil)
  end

  @spec search(conn(), search_map()) :: conn()
  def search(conn, %{"city" => city_name}) do
    with {:ok, result} <- perform_request!(city_name) do
      case result do
        {:ok, body} ->
          render(conn, "index.html", data: body)

        {:unauthorized, message} ->
          put_flash_and_redirect(conn, :info, message)

        {:error, message} ->
          put_flash_and_redirect(conn, :error, message)
      end
    end
  end

  @spec perform_request!(city_name :: binary()) :: {:ok, any()}
  defp perform_request!(city_name) do
    Cache.fetch(
      city_name,
      @ttl_sec,
      fn -> @api_client.get_weather_data(city_name) end
    )
  end

  @spec put_flash_and_redirect(conn(), key :: :error | :info, binary()) :: conn()
  defp put_flash_and_redirect(conn, key, message) do
    conn
    |> put_flash(key, message)
    |> redirect(to: "/")
  end
end
