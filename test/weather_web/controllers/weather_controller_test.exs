defmodule WeatherWeb.WeatherControllerTest do
  use WeatherWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")

    assert html_response(conn, 200) =~ "Search by city"
  end

  describe "POST /search" do
    test "when success result", %{conn: conn} do
      conn = post(conn, "/search", city: "success")

      assert html_response(conn, 200) =~ "Moscow, RU"
      assert html_response(conn, 200) =~ "<b>Weather:</b> snow"
      assert html_response(conn, 200) =~ "<b>Wind:</b> 3.04 m/s"
    end

    test "when failure result", %{conn: conn} do
      conn = post(conn, "/search", city: "invalid param")

      assert redirected_to(conn) == "/"

      assert get_flash(conn, :error) == "Error message text"

      assert conn.status == 302
    end
  end
end
