defmodule RxDelivery.Pharmacies.Location do
  use Ecto.Schema
  import Ecto.Changeset

  alias RxDelivery.Pharmacies.Pharmacy

  schema "locations" do
    field :latitude, :string
    field :longitude, :string
    belongs_to(:pharmacy, Pharmacy)

    timestamps()
  end

  @doc false
  def changeset(location, attrs) do
    location
    |> cast(attrs, [:latitude, :longitude, :pharmacy_id])
    |> assoc_constraint(:pharmacy)
    |> validate_required([:latitude, :longitude, :pharmacy_id])
    |> unique_constraint(:pharmacy_id)
  end
end
