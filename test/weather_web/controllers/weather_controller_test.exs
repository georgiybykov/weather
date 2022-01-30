defmodule WeatherWeb.WeatherControllerTest do
  use WeatherWeb.ConnCase

  setup :register_and_log_in_user

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")

    assert html_response(conn, 200) =~ "Search by city"
  end

  describe "POST /search" do
    test "when success result", %{conn: conn} do
      conn = post(conn, "/search", city: "success")

      assert html_response(conn, 200) =~ "Success, <u>TT</u>"
      assert html_response(conn, 200) =~ "<b>Weather:</b> clear sky"
      assert html_response(conn, 200) =~ "<b>Wind:</b> 3.68 m/s"
    end

    test "when failure result", %{conn: conn} do
      conn = post(conn, "/search", city: "invalid")

      assert redirected_to(conn) == "/"

      assert get_flash(conn, :error) == "Error message text"

      assert conn.status == 302
    end
  end
end
