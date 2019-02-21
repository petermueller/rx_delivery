defmodule RxDeliveryWeb.LayoutView do
  use RxDeliveryWeb, :view

  def my_pharmacy_link(conn) do
    current_pharmacy = Auth.current_pharmacy(conn)
    link("My Pharmacy", to: Routes.pharmacy_path(conn, :show, current_pharmacy))
  end
end
