defmodule Weather.ApiClients.OpenWeatherMock do
  @moduledoc """
  An API client for making requests to an external OpenWeather service.
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
        {:ok, success_body()}

      _ ->
        {:error, "Error message text"}
    end
  end

  defp success_body do
    %{
      "base" => "stations",
      "clouds" => %{"all" => 100},
      "cod" => 200,
      "coord" => %{"lat" => 55.7522, "lon" => 37.6156},
      "dt" => 1_642_867_643,
      "id" => 524_901,
      "main" => %{
        "feels_like" => -8.77,
        "grnd_level" => 993,
        "humidity" => 96,
        "pressure" => 1012,
        "sea_level" => 1012,
        "temp" => -4.35,
        "temp_max" => -3.71,
        "temp_min" => -4.85
      },
      "name" => "Moscow",
      "snow" => %{"1h" => 0.92},
      "sys" => %{
        "country" => "RU",
        "id" => 47_754,
        "sunrise" => 1_642_830_034,
        "sunset" => 1_642_858_871,
        "type" => 2
      },
      "timezone" => 10_800,
      "visibility" => 435,
      "weather" => [
        %{"description" => "snow", "icon" => "13n", "id" => 601, "main" => "Snow"}
      ],
      "wind" => %{"deg" => 107, "gust" => 6.8, "speed" => 3.04}
    }
  end
end
