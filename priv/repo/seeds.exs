# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     RxDelivery.Repo.insert!(%RxDelivery.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias RxDelivery.Pharmacies
alias RxDelivery.Prescriptions
alias RxDelivery.Patients

# Pharmacys with Locations
pharmacies =
  [
    %{name: "Alfa Pharmacy"},
    %{name: "Bravo Pharmacy"},
  ]
  |> Enum.map(&Pharmacies.create_pharmacy!/1)

locations =
  [
    %{latitude: "39.9612", longitude: "82.9988"},
    %{latitude: "40.9612", longitude: "72.9988"},
  ]
  |> Enum.zip(pharmacies)
  |> Enum.map(fn {loc, pharmacy} ->
    loc
    |> Map.put(:pharmacy_id, pharmacy.id)
    |> Pharmacies.create_location!()
  end)

# Prescriptions
prescriptions =
  [
    %{name: "Allegra"},
    %{name: "Rolaids"},
  ]
  |> Enum.map(&Prescriptions.create_prescription!/1)

# Patients
patients =
  [
    %{first_name: "First", last_name: "User"},
    %{first_name: "Second", last_name: "User"},
  ]
  |>  Enum.map(&Patients.create_patient!/1)

# Orders
Enum.zip([locations, prescriptions, patients])
|> Enum.each(fn {%{id: location_id}, %{id: prescription_id}, %{id: patient_id}} ->
  Patients.create_order!(
    %{
      location_id: location_id,
      prescription_id: prescription_id,
      patient_id: patient_id,
    }
  )
end)
