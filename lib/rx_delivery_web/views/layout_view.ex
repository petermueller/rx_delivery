defmodule RxDeliveryWeb.LayoutView do
  use RxDeliveryWeb, :view

  def my_pharmacy_link(conn) do
    current_pharmacy = Auth.current_pharmacy(conn)
    link("My Pharmacy", to: Routes.pharmacy_path(conn, :show, current_pharmacy))
  end

  def new_order_link(conn) do
    link("Enter an Order", to: Routes.order_path(conn, :new))
  end
end
