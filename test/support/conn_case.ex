defmodule RxDeliveryWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      use Phoenix.ConnTest
      alias RxDeliveryWeb.Router.Helpers, as: Routes

      # The default endpoint for testing
      @endpoint RxDeliveryWeb.Endpoint
    end
  end

  @default_opts [
      store: :cookie,
      key: "secretkey",
      encryption_salt: "encrypted cookie salt",
      signing_salt: "signing salt",
    ]
  @signing_opts Plug.Session.init(Keyword.put(@default_opts, :encrypt, false))

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(RxDelivery.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(RxDelivery.Repo, {:shared, self()})
    end


    {conn, pharmacy} = if tags[:authenticated_pharmacy] do
      pharmacy = RxDelivery.Fixtures.pharmacy()
      conn =
        Phoenix.ConnTest.build_conn()
        |> Plug.Session.call(@signing_opts)
        |> Plug.Conn.fetch_session()
        |> RxDeliveryWeb.Helpers.Auth.signin!(pharmacy)
      {conn, pharmacy}
    else
      {Phoenix.ConnTest.build_conn(), nil}
    end

    {:ok, conn: conn, pharmacy: pharmacy}
  end
end
