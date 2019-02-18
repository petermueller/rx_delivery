defmodule RxDelivery.Prescriptions.Prescription do
  use Ecto.Schema
  import Ecto.Changeset


  schema "prescriptions" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(prescription, attrs) do
    prescription
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
