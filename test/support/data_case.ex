defmodule Weather.DataCase do
  @moduledoc """
  This module defines the setup for tests requiring
  access to the application's data layer.

  You may define functions here to be used as helpers in
  your tests.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use Weather.DataCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate

  @type open_weather_response ::
          %HTTPoison.Response{
            :body => binary(),
            :status_code => pos_integer()
          }

  using do
    quote do
      alias Weather.Repo

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import Weather.DataCase
    end
  end

  setup tags do
    pid = Ecto.Adapters.SQL.Sandbox.start_owner!(Weather.Repo, shared: not tags[:async])
    on_exit(fn -> Ecto.Adapters.SQL.Sandbox.stop_owner(pid) end)
    :ok
  end

  @doc """
  A helper that transforms changeset errors into a map of messages.
      assert {:error, changeset} = Accounts.create_user(%{password: "short"})
      assert "password is too short" in errors_on(changeset).password
      assert %{password: ["password is too short"]} = errors_on(changeset)
  """
  def errors_on(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {message, opts} ->
      Regex.replace(~r"%{(\w+)}", message, fn _, key ->
        opts |> Keyword.get(String.to_existing_atom(key), key) |> to_string()
      end)
    end)
  end

  @spec success_response() :: open_weather_response
  def success_response do
    %HTTPoison.Response{
      body: "{\"coord\":{\"lon\":-61.4833,\"lat\":10.65},
          \"weather\":[{\"id\":800,\"main\":\"Clear\",\"description\":\"clear sky\",\"icon\":\"01d\"}],
          \"base\":\"stations\",\"main\":{\"temp\":29.61,\"feels_like\":31.75,\"temp_min\":28.86,
          \"temp_max\":30.55,\"pressure\":1014,\"humidity\":58},\"visibility\":10000,
          \"wind\":{\"speed\":3.68,\"deg\":54,\"gust\":4.94},\"clouds\":{\"all\":6},
          \"dt\":1642878733,\"sys\":{\"type\":2,\"id\":2002897,\"country\":\"TT\",
          \"sunrise\":1642847349,\"sunset\":1642889133},\"timezone\":-14400,\"id\":3573652,
          \"name\":\"Success\",\"cod\":200}",
      status_code: 200
    }
  end

  @spec unauthorized_response() :: open_weather_response
  def unauthorized_response do
    %HTTPoison.Response{
      body:
        "{\"cod\":401, \"message\": \"Invalid API key. Please see http://openweathermap.org/faq#error401 for more info.\"}",
      status_code: 401
    }
  end

  @spec not_found_response() :: open_weather_response
  def not_found_response do
    %HTTPoison.Response{
      body: "{\"cod\":\"404\",\"message\":\"city not found\"}",
      status_code: 404
    }
  end
end
