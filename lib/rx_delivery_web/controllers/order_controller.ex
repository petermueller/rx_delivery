defmodule RxDeliveryWeb.OrderController do
  use RxDeliveryWeb, :controller

  alias RxDelivery.{Patients, Pharmacies, Prescriptions}
  alias RxDelivery.Patients.Order

  plug :redirect_unauthenticated

  def index(conn, _params) do
    orders = Patients.list_orders(:with_assocs)
    render(conn, "index.html", orders: orders)
  end

  def new(conn, _params) do
    changeset = Patients.change_order(%Order{})
    render_with_all_assocs_assigned(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"order" => order_params}) do
    order_params =
      order_params
      |> Map.put(:location_id, value)
    case Patients.create_order() do
      {:ok, order} ->
        conn
        |> put_flash(:info, "Order created successfully.")
        |> redirect(to: Routes.order_path(conn, :show, order))

      {:error, %Ecto.Changeset{} = changeset} ->
        render_with_all_assocs_assigned(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    order = Patients.get_order!(id, :with_assocs)
    render(conn, "show.html", order: order)
  end

  def edit(conn, %{"id" => id}) do
    order = Patients.get_order!(id)
    changeset = Patients.change_order(order)
    render_with_all_assocs_assigned(conn, "edit.html", order: order, changeset: changeset)
  end

  def update(conn, %{"id" => id, "order" => order_params}) do
    order = Patients.get_order!(id)

    case Patients.update_order(order, order_params) do
      {:ok, order} ->
        conn
        |> put_flash(:info, "Order updated successfully.")
        |> redirect(to: Routes.order_path(conn, :show, order))

      {:error, %Ecto.Changeset{} = changeset} ->
        render_with_all_assocs_assigned(conn, "edit.html", order: order, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    order = Patients.get_order!(id)
    {:ok, _order} = Patients.delete_order(order)

    conn
    |> put_flash(:info, "Order deleted successfully.")
    |> redirect(to: Routes.order_path(conn, :index))
  end

  def render_with_all_assocs_assigned(conn, action_or_template, rest) do
    rest =
      rest
      |> Keyword.put_new_lazy(:patients, &Patients.list_patients/0)
      |> Keyword.put_new_lazy(:prescriptions, &Prescriptions.list_prescriptions/0)
      |> Keyword.put_new_lazy(:pharmacies, fn -> Pharmacies.only_pharmacies_with_locations end)

    render(conn, action_or_template, rest)
  end

  defp redirect_unauthenticated(conn, _) do
    case Auth.signed_in?(conn) do
      false ->
        redirect(conn, to: Routes.registration_path(conn, :new))
        |> halt()
      _ -> conn
    end
  end
end
