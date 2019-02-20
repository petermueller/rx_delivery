defmodule RxDelivery.Patients.Order do
  use Ecto.Schema
  import Ecto.Changeset

  alias RxDelivery.Patients.Patient
  alias RxDelivery.Prescriptions.Prescription
  alias RxDelivery.Pharmacies.Location

  schema "orders" do
    belongs_to(:patient, Patient)
    belongs_to(:prescription, Prescription)
    belongs_to(:location, Location)

    timestamps()
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [:patient_id, :prescription_id, :location_id])
    |> assoc_constraint(:patient)
    |> assoc_constraint(:prescription)
    |> assoc_constraint(:location)
    |> validate_required([:patient_id, :prescription_id, :location_id])
  end
end
