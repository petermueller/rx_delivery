defmodule RxDelivery.Patients.Order do
  use Ecto.Schema
  import Ecto.Changeset


  schema "orders" do
    field :patient_id, :id
    field :prescription_id, :id
    field :location_id, :id

    timestamps()
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [])
    |> validate_required([])
  end
end
