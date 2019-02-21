defmodule RxDelivery.Pharmacies.Pharmacy do
  use Ecto.Schema
  import Ecto.Changeset


  schema "pharmacies" do
    field :encrypted_password, :string
    field :username, :string
    field :name, :string
    has_one :location, RxDelivery.Pharmacies.Location

    timestamps()
  end

  @doc false
  def changeset(pharmacy, attrs) do
    pharmacy
    |> cast(attrs, [:name, :username, :encrypted_password])
    |> validate_required([:name, :username, :encrypted_password])
    |> unique_constraint(:name)
    |> unique_constraint(:username)
    |> update_change(:encrypted_password, &Bcrypt.hash_pwd_salt/1)
  end
end
