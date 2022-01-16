defmodule WeatherWeb.WeatherController do
  use WeatherWeb, :controller

  alias Weather.WeatherInfo

  def index(conn, _params) do
    render(conn, "index.html", data: nil)
  end

  def search(conn, %{"city" => %{"name" => city_name}}) do
    city_name
    |> WeatherInfo.get_weather_data()
    |> response(conn)
  end

  defp response(body, conn) do
    case body["cod"] do
      200 -> render(conn, "index.html", data: body)
      401 -> put_flash_and_redirect(conn, :error, "Invalid API key. Please contact to support.")
      404 -> put_flash_and_redirect(conn, :notice, String.capitalize(body["message"]))
      _ -> put_flash_and_redirect(conn, :info, String.capitalize(body["message"]))
    end
  end

  defp put_flash_and_redirect(conn, key, message) do
    conn
    |> put_flash(key, message)
    |> redirect(to: "/")
  end
end
