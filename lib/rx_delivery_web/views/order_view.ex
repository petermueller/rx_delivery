defmodule RxDeliveryWeb.OrderView do
  use RxDeliveryWeb, :view

  alias RxDelivery.Patients.{Order, Patient}
  alias RxDelivery.Prescriptions.Prescription

  def verbose_order_info(%Order{} = order) do
    "Prescription: #{prescription_name(order.prescription)} for #{patient_name(order.patient)}"
  end
  def verbose_order_info(_), do: unknown_order_info()

  def basic_order_info(%Order{} = order) do
    patient_name(order.patient) <> ": " <> prescription_name(order.prescription)
  end
  def basic_order_info(_), do: unknown_order_info()

  defp patient_name(%Patient{first_name: first_name, last_name: last_name}) do
    first_name <> " " <> last_name
  end
  defp patient_name(_) do
    "Unknown Patient"
  end

  defp prescription_name(%Prescription{name: prescription_name}), do: prescription_name
  defp prescription_name(_), do: "Unknown Prescription"

  defp unknown_order_info, do: "Unknown Order"
end
