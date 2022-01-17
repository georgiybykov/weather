defmodule Weather.ApiClients.OpenWeather do
  @moduledoc false

  def get_weather_data(city_name) do
    Application.get_env(:weather, __MODULE__)
    |> fetch_full_url(city_name)
    |> HTTPoison.get!()
    |> decode_response_body()
    |> handle()
  end

  defp fetch_full_url(open_weather_config, city_name) do
    open_weather_config[:url] <>
      "&q=#{String.capitalize(city_name)}" <>
      "&appid=#{open_weather_config[:app_id]}"
  end

  defp decode_response_body(response), do: Jason.decode!(response.body)

  defp handle(response_body) do
    case response_body["cod"] do
      200 ->
        {:ok, response_body}

      401 ->
        {:unauthorized, "Invalid API key. Please contact to support."}

      404 ->
        {:not_found, String.capitalize(response_body["message"])}

      _ ->
        {:unknown, String.capitalize(response_body["message"])}
    end
  end
end
