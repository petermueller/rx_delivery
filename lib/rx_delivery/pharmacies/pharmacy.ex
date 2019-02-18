defmodule RxDelivery.Pharmacies.Pharmacy do
  use Ecto.Schema
  import Ecto.Changeset


  schema "pharmacies" do
    field :name, :string
    has_one :location, RxDelivery.Pharmacies.Location

    timestamps()
  end

  @doc false
  def changeset(pharmacy, attrs) do
    pharmacy
    |> cast(attrs, [:name])
    |> validate_required(:name)
    |> unique_constraint(:name)
  end
end
