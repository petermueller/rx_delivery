defmodule RxDeliveryWeb.PharmacyControllerTest do
  use RxDeliveryWeb.ConnCase

  alias RxDelivery.Pharmacies

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  def fixture(:pharmacy) do
    {:ok, pharmacy} = Pharmacies.create_pharmacy(@create_attrs)
    pharmacy
  end

  describe "index" do
    test "lists all pharmacies", %{conn: conn} do
      conn = get(conn, Routes.pharmacy_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Pharmacies"
    end
  end

  describe "new pharmacy" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.pharmacy_path(conn, :new))
      assert html_response(conn, 200) =~ "New Pharmacy"
    end
  end

  describe "create pharmacy" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.pharmacy_path(conn, :create), pharmacy: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.pharmacy_path(conn, :show, id)

      conn = get(conn, Routes.pharmacy_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Pharmacy"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.pharmacy_path(conn, :create), pharmacy: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Pharmacy"
    end
  end

  describe "edit pharmacy" do
    setup [:create_pharmacy]

    test "renders form for editing chosen pharmacy", %{conn: conn, pharmacy: pharmacy} do
      conn = get(conn, Routes.pharmacy_path(conn, :edit, pharmacy))
      assert html_response(conn, 200) =~ "Edit Pharmacy"
    end
  end

  describe "update pharmacy" do
    setup [:create_pharmacy]

    test "redirects when data is valid", %{conn: conn, pharmacy: pharmacy} do
      conn = put(conn, Routes.pharmacy_path(conn, :update, pharmacy), pharmacy: @update_attrs)
      assert redirected_to(conn) == Routes.pharmacy_path(conn, :show, pharmacy)

      conn = get(conn, Routes.pharmacy_path(conn, :show, pharmacy))
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, pharmacy: pharmacy} do
      conn = put(conn, Routes.pharmacy_path(conn, :update, pharmacy), pharmacy: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Pharmacy"
    end
  end

  describe "delete pharmacy" do
    setup [:create_pharmacy]

    test "deletes chosen pharmacy", %{conn: conn, pharmacy: pharmacy} do
      conn = delete(conn, Routes.pharmacy_path(conn, :delete, pharmacy))
      assert redirected_to(conn) == Routes.pharmacy_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.pharmacy_path(conn, :show, pharmacy))
      end
    end
  end

  defp create_pharmacy(_) do
    pharmacy = fixture(:pharmacy)
    {:ok, pharmacy: pharmacy}
  end
end
