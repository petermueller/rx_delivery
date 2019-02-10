defmodule RxDelivery.Repo.Migrations.CreatePharmacies do
  use Ecto.Migration

  def change do
    create table(:pharmacies) do
      add :name, :string, null: false

      timestamps()
    end

    create unique_index(:pharmacies, [:name])
  end
end
