defmodule RxDeliveryWeb.PharmacyControllerTest do
  use RxDeliveryWeb.ConnCase

  alias RxDelivery.Pharmacies

  @create_attrs %{
    name: "some name",
    username: "some username",
    encrypted_password: "some encrypted_password",
  }
  @update_attrs %{
    name: "some updated name",
    username: "some updated username",
    encrypted_password: "some updated encrypted_password",
  }
  @invalid_attrs %{
    name: nil,
    username: nil,
    encrypted_password: nil,
  }

  describe "index" do
    test "lists all pharmacies", %{conn: conn} do
      conn = get(conn, Routes.pharmacy_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Pharmacies"
    end
  end

  describe "new pharmacy" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.registration_path(conn, :new))
      assert html_response(conn, 200) =~ "Sign Up with your Pharmacy's Information"
    end
  end

  describe "create pharmacy" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.registration_path(conn, :create), pharmacy: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.pharmacy_path(conn, :show, id)

      conn = get(conn, Routes.pharmacy_path(conn, :show, id))
      assert html_response(conn, 200) =~ "some name"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.registration_path(conn, :create), pharmacy: @invalid_attrs)
      assert html_response(conn, 200) =~ "Sign Up with your Pharmacy's Information"
    end
  end
end
