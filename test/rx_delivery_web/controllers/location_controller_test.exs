defmodule RxDeliveryWeb.LocationControllerTest do
  use RxDeliveryWeb.ConnCase

  alias RxDelivery.Pharmacies

  @pharmacy_attrs %{name: "Butt Drugs, Inc."}
  @create_attrs %{latitude: "some latitude", longitude: "some longitude"}
  @update_attrs %{latitude: "some updated latitude", longitude: "some updated longitude"}
  @invalid_attrs %{latitude: nil, longitude: nil}

  def fixture(:pharmacy), do: Pharmacies.create_pharmacy!(@pharmacy_attrs)
  def fixture(:location, pharmacy) do
    @create_attrs
    |> Map.put(:pharmacy_id, pharmacy.id)
    |> Pharmacies.create_location!()
  end

  describe "without a pharmacy" do
    test "redirects to pharmacy index", %{conn: conn} do
      conn = get(conn, Routes.pharmacy_location_path(conn, :show, 10_000))
      assert html_response(conn, 404)
    end
  end

  describe "new location" do
    setup [:create_pharmacy]

    test "renders form", %{conn: conn, pharmacy: pharmacy} do
      conn = get(conn, Routes.pharmacy_location_path(conn, :new, pharmacy))
      assert html_response(conn, 200) =~ "Add Location for Butt Drugs, Inc."
    end
  end

  describe "create location" do
    setup [:create_pharmacy]

    test "redirects to show when data is valid", %{conn: conn, pharmacy: pharmacy} do
      conn = post(conn, Routes.pharmacy_location_path(conn, :create, pharmacy), location: @create_attrs)
      assert redirected_to(conn) == Routes.pharmacy_location_path(conn, :show, pharmacy)

      conn = get(conn, Routes.pharmacy_location_path(conn, :show, pharmacy))
      assert html_response(conn, 200) =~ "some latitude"
    end

    test "renders errors when data is invalid", %{conn: conn, pharmacy: pharmacy} do
      conn = post(conn, Routes.pharmacy_location_path(conn, :create, pharmacy), location: @invalid_attrs)
      assert html_response(conn, 200) =~ "Add Location for Butt Drugs, Inc."
    end
  end

  describe "edit location" do
    setup [:create_pharmacy, :with_location]

    test "renders form for editing chosen location", %{conn: conn, pharmacy: pharmacy} do
      conn = get(conn, Routes.pharmacy_location_path(conn, :edit, pharmacy))
      assert html_response(conn, 200) =~ "Edit Location"
    end
  end

  describe "update location" do
    setup [:create_pharmacy, :with_location]

    test "redirects when data is valid", %{conn: conn, pharmacy: pharmacy} do
      conn = put(conn, Routes.pharmacy_location_path(conn, :update, pharmacy), location: @update_attrs)
      assert redirected_to(conn) == Routes.pharmacy_location_path(conn, :show, pharmacy)

      conn = get(conn, Routes.pharmacy_location_path(conn, :show, pharmacy))
      assert html_response(conn, 200) =~ "some updated latitude"
    end

    test "renders errors when data is invalid", %{conn: conn, pharmacy: pharmacy} do
      conn = put(conn, Routes.pharmacy_location_path(conn, :update, pharmacy), location: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Location"
    end
  end

  describe "delete location" do
    setup [:create_pharmacy, :with_location]

    test "deletes chosen location", %{conn: conn, pharmacy: pharmacy} do
      conn = delete(conn, Routes.pharmacy_location_path(conn, :delete, pharmacy))
      assert redirected_to(conn) == Routes.pharmacy_location_path(conn, :new, pharmacy)

      conn = get(conn, Routes.pharmacy_location_path(conn, :show, pharmacy))
      assert redirected_to(conn) == Routes.pharmacy_location_path(conn, :new, pharmacy)
    end
  end

  defp create_pharmacy(_), do: {:ok, pharmacy: fixture(:pharmacy)}

  defp with_location(%{pharmacy: pharmacy}), do: {:ok, location: fixture(:location, pharmacy)}
end
