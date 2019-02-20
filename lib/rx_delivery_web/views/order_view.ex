defmodule RxDeliveryWeb.OrderView do
  use RxDeliveryWeb, :view

  alias RxDelivery.Patients.{Order, Patient}
  alias RxDelivery.Pharmacies.{Pharmacy}
  alias RxDelivery.Prescriptions.Prescription

  def format_list_for_select_tag(list) do
    Enum.map(list, &format_item_for_select_tag/1)
  end

  def verbose_order_info(%Order{} = order) do
    "Prescription: #{prescription_name(order.prescription)} for #{patient_name(order.patient)}"
  end

  def basic_order_info(%Order{} = order) do
    patient_name(order.patient) <> ": " <> prescription_name(order.prescription)
  end

  defp patient_name(%Patient{first_name: first_name, last_name: last_name}) do
    first_name <> " " <> last_name
  end

  defp pharmacy_name(%Pharmacy{name: pharmacy_name}), do: pharmacy_name

  defp prescription_name(%Prescription{name: prescription_name}), do: prescription_name

  defp format_item_for_select_tag(%Patient{} = patient) do
    [key: patient_name(patient), value: patient.id]
  end
  defp format_item_for_select_tag(%Pharmacy{} = pharmacy) do
    [key: pharmacy_name(pharmacy), value: pharmacy.location.id]
  end
  defp format_item_for_select_tag(%Prescription{} = prescription) do
    [key: prescription_name(prescription), value: prescription.id]
  end
end
