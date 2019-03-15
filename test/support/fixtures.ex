defmodule RxDelivery.Fixtures do
  alias RxDelivery.{Patients, Prescriptions, Pharmacies}


  @location_attrs %{latitude: "34.0000", longitude: "45.1111"}
  @patient_attrs %{first_name: "Bob", last_name: "Dobbs"}
  @pharmacy_attrs %{
    name: "Butt Drugs, Inc.",
    username: "buttdrugs",
    encrypted_password: "password!"
  }
  @prescription_attrs %{name: "Apple Flavoring, liquid"}

  @updated_pharmacy_attrs %{
    name: "Not Just A Dispensary, LLC.",
    username: "notbuttdrugs",
    encrypted_password: "updatedpw"
  }
  @combined_attrs %{
    location_attrs: @location_attrs,
    patient_attrs: @patient_attrs,
    prescription_attrs: @prescription_attrs
  }

  def location(attrs \\ %{}) do
    attrs
    |> Enum.into(@location_attrs)
    |> Map.put_new_lazy(:pharmacy_id, fn -> pharmacy().id end)
    |> Pharmacies.create_location!()
  end

  def order(attrs \\ order_attrs()), do: Patients.create_order!(attrs)

  def order_attrs(attrs \\ @combined_attrs) do
    %{
      location_attrs: location_attrs,
      patient_attrs: patient_attrs,
      prescription_attrs: prescription_attrs
    } = Enum.into(attrs, @combined_attrs)

    %{
      location_id: location(location_attrs).id,
      patient_id: patient(patient_attrs).id,
      prescription_id: prescription(prescription_attrs).id
    }
  end

  def patient(attrs \\ %{}) do
    attrs
    |> Enum.into(@patient_attrs)
    |> Patients.create_patient!()
  end

  def pharmacy(attrs \\ %{}) do
    attrs
    |> Enum.into(@pharmacy_attrs)
    |> Pharmacies.create_pharmacy!()
  end

  def updated_pharmacy(attrs \\ %{}) do
    attrs
    |> Enum.into(@updated_pharmacy_attrs)
    |> pharmacy()
  end

  def prescription(attrs \\ %{}) do
    attrs
    |> Enum.into(@prescription_attrs)
    |> Prescriptions.create_prescription!()
  end
end
