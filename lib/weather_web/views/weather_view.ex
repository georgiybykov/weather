defmodule WeatherWeb.WeatherView do
  use WeatherWeb, :view

  @spec render_weather_info(map()) :: Phoenix.LiveView.Rendered.t()
  def render_weather_info(assigns) do
    %{
      "name" => name,
      "sys" => %{"country" => country},
      "weather" => [%{"description" => description}],
      "main" => %{
        "temp" => temp,
        "temp_min" => temp_min,
        "temp_max" => temp_max,
        "pressure" => pressure
      },
      "wind" => %{"speed" => speed},
      "coord" => %{"lat" => latitude, "lon" => longitude}
    } = assigns

    ~H"""
    <p>
    	<%= name %>, <%= country %>
    </p>

    <ul>
    	<li>
    		<b>Weather:</b> <%= description %>
    	</li>

    	<li>
    		<b>Temperature:</b> <%= temp %> °С
    	</li>

    	<li>
    		Temperature <b>from</b> <%= temp_min %> °С <b>to</b> <%= temp_max %> °С
    	</li>

    	<li>
    		<b>Wind:</b> <%= speed %> m/s
    	</li>

    	<li>
    		<b>Pressure:</b> <%= pressure %> hpa
    	</li>
    </ul>

    <ul>
    	<b>Geo coords:</b>
    		<li>latitude: <%= latitude %></li>
    		<li>longitude: <%= longitude %></li>
    </ul>
    """
  end
end
