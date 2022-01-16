defmodule Weather.WeatherInfo do
  @moduledoc false

  def get_weather_data(city_name) do
    open_weather = Application.get_env(:weather, __MODULE__)

    full_url =
      open_weather[:url] <>
        "&q=#{String.capitalize(city_name)}" <>
        "&appid=#{open_weather[:app_id]}"

    response = HTTPoison.get!(full_url)

    Jason.decode!(response.body)
  end
end
