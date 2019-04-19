defmodule RxDeliveryWeb.OrderControllerTest do
  use RxDeliveryWeb.ConnCase

  alias RxDelivery.{Fixtures, Patients}

  @invalid_attrs %{
    patient_id:      10_000,
    prescription_id: 10_000,
    location_id:     10_000,
  }

  @moduletag :authenticated_pharmacy

  def fixture(:order) do
    {:ok, order} = Patients.create_order(Fixtures.order_attrs())
    order
  end

  describe "index" do
    setup [:create_order]
    test "lists all orders", %{conn: conn, order: order} do
      %{first_name: first_name, last_name: last_name} = Patients.get_patient!(order.patient_id)
      conn = get(conn, Routes.order_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Orders"
      assert html_response(conn, 200) =~ first_name <> " " <> last_name
    end
  end

  describe "new order" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.order_path(conn, :new))
      assert html_response(conn, 200) =~ "New Order"
    end

    test "by an unauthenticated user redirects to sign-up" do
      conn = get(conn, Routes.order_path(conn, :new))
      assert redirected_to(conn) == Routes.registration_path(conn, :new)
    end
  end

  describe "create order" do
    test "creates an for the signed-in pharmacy and redirects to show when data is valid", %{conn: conn, pharmacy: pharmacy} do
      form_attrs =
        Fixtures.order_attrs()
        |> Map.take([:patient_id, :prescription_id])
      conn = post(conn, Routes.order_path(conn, :create), order: form_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.order_path(conn, :show, id)


      pharmacy = Pharmacies.get_pharmacy!(pharmacy.id, with: :location)
      assert %{location_id: pharmacy.location.id} == Patients.get_order!(id)

      conn = get(conn, Routes.order_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Order Information"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.order_path(conn, :create), order: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Order"
    end
  end

  describe "show order" do
    setup [:create_order]

    test "renders information about the order", %{conn: conn, order: order} do
      order = Patients.get_order!(order.id, :with_assocs)
      %{first_name: "Bob" = first_name, last_name: last_name} = order.patient
      %{name: prescription_name} = order.prescription
      expected_info = "Prescription: #{prescription_name} for #{first_name} #{last_name}"


      conn = get(conn, Routes.order_path(conn, :show, order.id))
      assert html_response(conn, 200) =~ "Order Information"
      assert html_response(conn, 200) =~ expected_info
    end
  end

  describe "edit order" do
    setup [:create_order]

    test "renders form for editing chosen order", %{conn: conn, order: order} do
      order = Patients.get_order!(order.id, :with_assocs)
      %{first_name: "Bob" = first_name, last_name: last_name} = order.patient

      conn = get(conn, Routes.order_path(conn, :edit, order))
      assert html_response(conn, 200) =~ "Edit Order"
      assert html_response(conn, 200) =~ first_name <> " " <> last_name
    end
  end

  describe "update order" do
    setup [:create_order]

    test "redirects when data is valid", %{conn: conn, order: order} do
      updated_order_attrs =
        Fixtures.order_attrs(
          %{location_attrs: %{pharmacy_id: Fixtures.updated_pharmacy().id}}
        )
      conn = put(conn, Routes.order_path(conn, :update, order), order: updated_order_attrs)
      assert redirected_to(conn) == Routes.order_path(conn, :show, order)

      conn = get(conn, Routes.order_path(conn, :show, order))
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, order: order} do
      conn = put(conn, Routes.order_path(conn, :update, order), order: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Order"
    end
  end

  describe "delete order" do
    setup [:create_order]

    test "deletes chosen order", %{conn: conn, order: order} do
      conn = delete(conn, Routes.order_path(conn, :delete, order))
      assert redirected_to(conn) == Routes.order_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.order_path(conn, :show, order))
      end
    end
  end

  defp create_order(_) do
    order = fixture(:order)
    {:ok, order: order}
  end
end
