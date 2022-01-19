defmodule Weather.ApiClients.OpenWeather do
  @moduledoc """
  An API client for making requests to an external OpenWeather service.
  """

  @type weather_data ::
          {:ok, map()}
          | {:unauthorized, binary()}
          | {:error, binary()}

  @doc """
  Sends an HTTP request to the OpenWeather API
  to get weather data for the given city.
  Processes the response by return code.
  """
  @spec get_weather_data(city_name :: binary()) :: weather_data
  def get_weather_data(city_name) do
    Application.get_env(:weather, __MODULE__)
    |> fetch_full_url(city_name)
    |> HTTPoison.get!()
    |> decode_response_body()
    |> handle()
  end

  @spec fetch_full_url(map(), binary()) :: binary()
  defp fetch_full_url(open_weather_config, city_name) do
    open_weather_config[:url] <>
      "&q=#{String.capitalize(city_name)}" <>
      "&appid=#{open_weather_config[:app_id]}"
  end

  @spec decode_response_body(response :: HTTPoison.Response.t()) :: map()
  defp decode_response_body(response),
    do: Jason.decode!(response.body)

  @spec handle(response_body :: map()) :: weather_data
  defp handle(response_body) do
    case response_body["cod"] do
      200 ->
        {:ok, response_body}

      401 ->
        {:unauthorized, "Invalid API key. Please contact to support."}

      _ ->
        {:error, String.capitalize(response_body["message"])}
    end
  end
end
