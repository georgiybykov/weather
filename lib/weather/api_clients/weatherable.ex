defmodule Weather.ApiClients.Weatherable do
  @moduledoc "Behaviour for fetching weather data"

  @typedoc """
  Describes tuples for handled response, e.g.:
    {:ok, %{"cod" => 200, "name" => "City"}}
    {:unauthorized, "Invalid API key. Please contact to support."}
    {:error, "City not found"}
  """
  @type handled_response ::
          {:ok, map()}
          | {:unauthorized, binary()}
          | {:error, binary()}

  @doc """
  Sends an HTTP request to the OpenWeather API
  to gets weather data for the given city.
  Processes the response by return code.
  """
  @callback get_weather_data(binary()) :: handled_response
end
