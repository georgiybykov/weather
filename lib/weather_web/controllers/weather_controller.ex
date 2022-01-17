defmodule WeatherWeb.WeatherController do
  use WeatherWeb, :controller

  alias Weather.ApiClients.OpenWeather

  def index(conn, _params) do
    render(conn, "index.html", data: nil)
  end

  def search(conn, %{"city" => %{"name" => city_name}}) do
    city_name
    |> OpenWeather.get_weather_data()
    |> respond(conn)
  end

  defp respond(data, conn) do
    case data do
      {:ok, body} ->
        render(conn, "index.html", data: body)

      {:unauthorized, message} ->
        put_flash_and_redirect(conn, :error, message)

      {:not_found, message} ->
        put_flash_and_redirect(conn, :notice, message)

      {:unknown, message} ->
        put_flash_and_redirect(conn, :info, message)
    end
  end

  defp put_flash_and_redirect(conn, key, message) do
    conn
    |> put_flash(key, message)
    |> redirect(to: "/")
  end
end
