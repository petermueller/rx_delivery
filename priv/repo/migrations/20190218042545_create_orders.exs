defmodule RxDelivery.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders) do
      add :patient_id, references(:patients, on_delete: :nothing)
      add :prescription_id, references(:prescriptions, on_delete: :nothing)
      add :location_id, references(:locations, on_delete: :nothing)

      timestamps()
    end

    create index(:orders, [:patient_id])
    create index(:orders, [:prescription_id])
    create index(:orders, [:location_id])
  end
end
