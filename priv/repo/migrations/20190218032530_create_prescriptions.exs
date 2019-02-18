defmodule RxDelivery.Repo.Migrations.CreatePrescriptions do
  use Ecto.Migration

  def change do
    create table(:prescriptions) do
      add :name, :string

      timestamps()
    end

  end
end
