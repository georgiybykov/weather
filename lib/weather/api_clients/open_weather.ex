defmodule Weather.ApiClients.OpenWeather do
  @moduledoc """
  An API client for making requests to an external OpenWeather service.
  """

  @behaviour Weather.ApiClients.Weatherable

  @impl Weather.ApiClients.Weatherable
  def get_weather_data(city_name) do
    Application.get_env(:weather, __MODULE__)
    |> fetch_full_url(city_name)
    |> HTTPoison.get()
    |> decode_response_body()
    |> handle()
  end

  @spec fetch_full_url(map(), binary()) :: binary()
  defp fetch_full_url(open_weather_config, city_name) do
    open_weather_config[:url] <>
      "&q=#{String.capitalize(city_name)}" <>
      "&appid=#{open_weather_config[:app_id]}"
  end

  @spec decode_response_body({:error, HTTPoison.Error.t()} | {:ok, HTTPoison.Response.t()}) ::
          {:ok, map()} | {:error, Jason.DecodeError.t()} | {:error, binary()}
  defp decode_response_body({:error, _}), do: {:error, "Decode response error"}
  defp decode_response_body({:ok, response}), do: Jason.decode(response.body)

  @spec handle({:error, binary() | Jason.DecodeError.t()} | {:ok, map()}) ::
          {:ok, map()} | {:unauthorized, binary()} | {:error, binary()}
  defp handle({:error, reason}) do
    {:error, reason}
  end

  defp handle({:ok, %{"cod" => 200} = response_body}) do
    {:ok, response_body}
  end

  defp handle({:ok, %{"cod" => 401}}) do
    {:unauthorized, "Invalid API key. Please contact to support."}
  end

  defp handle({:ok, %{"message" => error_message}}) do
    {:error, String.capitalize(error_message)}
  end
end
