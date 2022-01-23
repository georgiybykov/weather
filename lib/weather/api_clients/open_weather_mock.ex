defmodule Weather.ApiClients.OpenWeatherMock do
  @moduledoc """
  A mock for requests to external API for OpenWeather service.
  """

  @type handled_response ::
          {:ok, map()}
          | {:unauthorized, binary()}
          | {:error, binary()}

  @doc """
  Sends an HTTP request to the OpenWeather API
  to get weather data for the given city.
  Processes the response by return code.
  """
  @spec get_weather_data(city_name :: binary()) :: handled_response
  def get_weather_data(params \\ "success") do
    case params do
      "success" ->
        {:ok, success()}

      _ ->
        {:error, "Error message text"}
    end
  end

  @spec success() :: map()
  def success do
    %{
      "base" => "stations",
      "clouds" => %{"all" => 6},
      "cod" => 200,
      "coord" => %{"lat" => 10.65, "lon" => -61.4833},
      "dt" => 1_642_878_733,
      "id" => 3_573_652,
      "main" => %{
        "feels_like" => 31.75,
        "humidity" => 58,
        "pressure" => 1014,
        "temp" => 29.61,
        "temp_max" => 30.55,
        "temp_min" => 28.86
      },
      "name" => "Success",
      "sys" => %{
        "country" => "TT",
        "id" => 2_002_897,
        "sunrise" => 1_642_847_349,
        "sunset" => 1_642_889_133,
        "type" => 2
      },
      "timezone" => -14_400,
      "visibility" => 10_000,
      "weather" => [
        %{
          "description" => "clear sky",
          "icon" => "01d",
          "id" => 800,
          "main" => "Clear"
        }
      ],
      "wind" => %{"deg" => 54, "gust" => 4.94, "speed" => 3.68}
    }
  end
end
