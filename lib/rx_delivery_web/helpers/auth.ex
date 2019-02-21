defmodule RxDeliveryWeb.Helpers.Auth do
  alias RxDelivery.Pharmacies
  alias RxDelivery.Pharmacies.Pharmacy
  alias Plug.Conn


  @doc """
  Returns a boolean of the return from `current_pharmacy/1`
  """
  def signed_in?(conn) do
    !!current_pharmacy(conn)
  end

  @doc """
  Takes and Sets `current_pharmacy_id` in the session,
  and stores the `current_pharmacy` in the connection assigns.

  Does not do ANY authentication.
  """
  def signin!(conn, %Pharmacy{id: id} = pharmacy) when not is_nil(id) do
    conn
    |> Conn.put_session(:current_pharmacy_id, pharmacy.id)
    |> Conn.assign(:current_pharmacy, pharmacy)
  end

  @doc """
  Clears `current_pharmacy_id` from the session,
  and sets `current_pharmacy` in the connection assigns to `nil`.
  """
  def signout!(conn) do
    conn
    |> Conn.delete_session(:current_pharmacy_id)
    |> Conn.assign(:current_pharmacy, nil)
  end

  @doc """
  Gets the `current_pharmacy` from the connection assigns.

  Relies on `load_current_pharmacy/2` having already assigned the pharmacy
  """
  def current_pharmacy(conn) do
    conn.assigns[:current_pharmacy]
  end

  @doc """
  Loads and sets the `current_pharmacy` in the connection assigns if it exists.

  Can be used as a plug, or directly with `load_current_pharmacy/1`

   Note: Relies on `signin!/1` and `signout!/1` under the hood.
  """
  def load_current_pharmacy(conn, _ \\ nil) do
    with(
      id       when not is_nil(id)       <- Conn.get_session(conn, :current_pharmacy_id),
      pharmacy when not is_nil(pharmacy) <- Pharmacies.get_pharmacy(id)
    ) do
      signin!(conn, pharmacy)
    else
      _ -> signout!(conn)
    end
  end
end
