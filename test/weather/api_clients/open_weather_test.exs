defmodule Weather.ApiClients.OpenWeatherTest do
  use Weather.DataCase, async: true

  import Mock

  alias Weather.ApiClients.OpenWeather
  alias Weather.ApiClients.OpenWeatherMock

  describe "#get_weather_data/1" do
    test "when everything is OK" do
      with_mock HTTPoison, get: fn _url -> success_response() end do
        handeled_response = OpenWeather.get_weather_data("Success")

        assert handeled_response == {:ok, OpenWeatherMock.success()}
      end
    end

    test "when given API key is invalid" do
      with_mock HTTPoison, get: fn _url -> unauthorized_response() end do
        handeled_response = OpenWeather.get_weather_data("City")

        assert handeled_response == {:unauthorized, "Invalid API key. Please contact to support."}
      end
    end

    test "when city does not exist" do
      with_mock HTTPoison, get: fn _url -> not_found_response() end do
        handeled_response = OpenWeather.get_weather_data("Nonexistent")

        assert handeled_response == {:error, "City not found"}
      end
    end
  end
end
