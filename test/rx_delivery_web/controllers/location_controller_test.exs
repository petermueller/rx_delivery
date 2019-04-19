defmodule RxDeliveryWeb.LocationControllerTest do
  use RxDeliveryWeb.ConnCase

  alias RxDelivery.Fixtures

  alias RxDelivery.Pharmacies

  @create_attrs %{latitude: "34.0000", longitude: "45.0000"}
  @update_attrs %{latitude: "34.1111", longitude: "45.1111"}
  @invalid_attrs %{latitude: nil, longitude: nil}

  @moduletag :authenticated_pharmacy

  def fixture(:location, pharmacy) do
    @create_attrs
    |> Map.put(:pharmacy_id, pharmacy.id)
    |> Pharmacies.create_location!()
  end

  describe "without a pharmacy" do
    test "renders a Not Found page", %{conn: conn} do
      conn = get(conn, Routes.pharmacy_location_path(conn, :show, 10_000))
      assert html_response(conn, 404)
    end
  end

  describe "new location" do
    test "renders form", %{conn: conn, pharmacy: pharmacy} do
      conn = get(conn, Routes.pharmacy_location_path(conn, :new, pharmacy))
      assert html_response(conn, 200) =~ "Add Location for " <> pharmacy.name
    end
  end

  describe "create location" do

    test "redirects to show when data is valid", %{conn: conn, pharmacy: pharmacy} do
      conn = post(conn, Routes.pharmacy_location_path(conn, :create, pharmacy), location: @create_attrs)
      assert redirected_to(conn) == Routes.pharmacy_location_path(conn, :show, pharmacy)

      conn = get(conn, Routes.pharmacy_location_path(conn, :show, pharmacy))
      assert html_response(conn, 200) =~ "34.0000"
    end

    test "renders errors when data is invalid", %{conn: conn, pharmacy: pharmacy} do
      conn = post(conn, Routes.pharmacy_location_path(conn, :create, pharmacy), location: @invalid_attrs)
      assert html_response(conn, 200) =~ "Add Location for " <> pharmacy.name
    end
  end

  describe "edit location" do
    setup [:with_location]

    test "renders form for editing chosen location", %{conn: conn, pharmacy: pharmacy} do
      conn = get(conn, Routes.pharmacy_location_path(conn, :edit, pharmacy))
      assert html_response(conn, 200) =~ "Edit Location"
    end
  end

  describe "edit location of another pharmacy" do
    setup [:other_pharmacy, :with_location]

    test "redirects back to the auth'd pharmacy", %{conn: conn, pharmacy: pharmacy, other_pharmacy: other_pharmacy} do
      conn = get(conn, Routes.pharmacy_location_path(conn, :edit, other_pharmacy))
      assert redirected_to(conn) == Routes.pharmacy_path(conn, :show, pharmacy)
    end
  end

  describe "update location" do
    setup [:with_location]

    test "redirects when data is valid", %{conn: conn, pharmacy: pharmacy} do
      conn = put(conn, Routes.pharmacy_location_path(conn, :update, pharmacy), location: @update_attrs)
      assert redirected_to(conn) == Routes.pharmacy_location_path(conn, :show, pharmacy)

      conn = get(conn, Routes.pharmacy_location_path(conn, :show, pharmacy))
      assert html_response(conn, 200) =~ "34.1111"
    end

    test "renders errors when data is invalid", %{conn: conn, pharmacy: pharmacy} do
      conn = put(conn, Routes.pharmacy_location_path(conn, :update, pharmacy), location: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Location"
    end
  end

  describe "delete location" do
    setup [:with_location]

    test "deletes chosen location", %{conn: conn, pharmacy: pharmacy} do
      conn = delete(conn, Routes.pharmacy_location_path(conn, :delete, pharmacy))
      assert redirected_to(conn) == Routes.pharmacy_location_path(conn, :new, pharmacy)

      conn = get(conn, Routes.pharmacy_location_path(conn, :show, pharmacy))
      assert redirected_to(conn) == Routes.pharmacy_location_path(conn, :new, pharmacy)
    end
  end

  defp other_pharmacy(_), do: {:ok, other_pharmacy: Fixtures.updated_pharmacy()}

  defp with_location(%{pharmacy: pharmacy}), do: {:ok, location: fixture(:location, pharmacy)}
end
