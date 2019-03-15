defmodule RxDelivery.Repo.Migrations.CreateLocations do
  use Ecto.Migration

  def change do
    create table(:locations) do
      add :latitude, :decimal
      add :longitude, :decimal
      add :pharmacy_id, references(:pharmacies, on_delete: :restrict), null: false

      timestamps()
    end

    create unique_index(:locations, [:pharmacy_id])
  end
end
