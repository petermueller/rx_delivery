defmodule RxDeliveryWeb.OrderController do
  use RxDeliveryWeb, :controller

  alias RxDelivery.Patients
  alias RxDelivery.Patients.Order

  def index(conn, _params) do
    orders = Patients.list_orders(:with_assocs)
    render(conn, "index.html", orders: orders)
  end

  def new(conn, _params) do
    changeset = Patients.change_order(%Order{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"order" => order_params}) do
    case Patients.create_order(order_params) do
      {:ok, order} ->
        conn
        |> put_flash(:info, "Order created successfully.")
        |> redirect(to: Routes.order_path(conn, :show, order))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    order = Patients.get_order!(id, :with_assocs)
    render(conn, "show.html", order: order)
  end

  def edit(conn, %{"id" => id}) do
    order = Patients.get_order!(id)
    changeset = Patients.change_order(order)
    render(conn, "edit.html", order: order, changeset: changeset)
  end

  def update(conn, %{"id" => id, "order" => order_params}) do
    order = Patients.get_order!(id)

    case Patients.update_order(order, order_params) do
      {:ok, order} ->
        conn
        |> put_flash(:info, "Order updated successfully.")
        |> redirect(to: Routes.order_path(conn, :show, order))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", order: order, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    order = Patients.get_order!(id)
    {:ok, _order} = Patients.delete_order(order)

    conn
    |> put_flash(:info, "Order deleted successfully.")
    |> redirect(to: Routes.order_path(conn, :index))
  end
end
