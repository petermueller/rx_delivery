defmodule RxDelivery.Repo.Migrations.AddPharmacyAuth do
  use Ecto.Migration

  def change do
    alter table(:pharmacies) do
      add :username, :string, null: false
      add :encrypted_password, :string, null: false
    end

    create unique_index(:pharmacies, [:username])
  end
end
