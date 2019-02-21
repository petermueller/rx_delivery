defmodule RxDelivery.PharmaciesTest do
  use RxDelivery.DataCase

  alias RxDelivery.Pharmacies

  describe "pharmacies" do
    alias RxDelivery.Pharmacies.Pharmacy

    @valid_attrs %{
      name: "some name",
      username: "some username",
      encrypted_password: "some encrypted_password",
    }
    @update_attrs %{
      name: "some updated name",
      username: "some updated username",
      encrypted_password: "some updated encrypted_password",
    }
    @invalid_attrs %{
      name: nil,
      username: nil,
      encrypted_password: nil,
    }

    def pharmacy_fixture(attrs \\ %{}) do
      {:ok, pharmacy} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Pharmacies.create_pharmacy()

      pharmacy
    end

    test "list_pharmacies/0 returns all pharmacies" do
      pharmacy = pharmacy_fixture()
      assert Pharmacies.list_pharmacies() == [pharmacy]
    end

    test "get_pharmacy!/1 returns the pharmacy with given id" do
      pharmacy = pharmacy_fixture()
      assert Pharmacies.get_pharmacy!(pharmacy.id) == pharmacy
    end

    test "create_pharmacy/1 with valid data creates a pharmacy" do
      assert {:ok, %Pharmacy{} = pharmacy} = Pharmacies.create_pharmacy(@valid_attrs)
      assert pharmacy.name == "some name"
    end

    test "create_pharmacy/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Pharmacies.create_pharmacy(@invalid_attrs)
    end

    test "update_pharmacy/2 with valid data updates the pharmacy" do
      pharmacy = pharmacy_fixture()
      assert {:ok, %Pharmacy{} = pharmacy} = Pharmacies.update_pharmacy(pharmacy, @update_attrs)
      assert pharmacy.name == "some updated name"
    end

    test "update_pharmacy/2 with invalid data returns error changeset" do
      pharmacy = pharmacy_fixture()
      assert {:error, %Ecto.Changeset{}} = Pharmacies.update_pharmacy(pharmacy, @invalid_attrs)
      assert pharmacy == Pharmacies.get_pharmacy!(pharmacy.id)
    end

    test "delete_pharmacy/1 deletes the pharmacy" do
      pharmacy = pharmacy_fixture()
      assert {:ok, %Pharmacy{}} = Pharmacies.delete_pharmacy(pharmacy)
      assert_raise Ecto.NoResultsError, fn -> Pharmacies.get_pharmacy!(pharmacy.id) end
    end

    test "change_pharmacy/1 returns a pharmacy changeset" do
      pharmacy = pharmacy_fixture()
      assert %Ecto.Changeset{} = Pharmacies.change_pharmacy(pharmacy)
    end
  end

  describe "locations" do
    alias RxDelivery.Pharmacies.Location

    @pharmacy_attrs %{name: "Butt Drugs, Inc."}
    @valid_attrs %{latitude: "some latitude", longitude: "some longitude"}
    @update_attrs %{latitude: "some updated latitude", longitude: "some updated longitude"}
    @invalid_attrs %{latitude: nil, longitude: nil}

    def location_fixture(attrs \\ %{}) do
      {:ok, location} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Pharmacies.create_location()

      location
    end

    setup [:create_pharmacy]

    test "list_locations/0 returns all locations", %{pharmacy: pharmacy} do
      location = location_fixture(pharmacy_id: pharmacy.id)
      assert Pharmacies.list_locations() == [location]
    end

    test "get_location!/1 returns the location with given id", %{pharmacy: pharmacy} do
      location = location_fixture(pharmacy_id: pharmacy.id)
      assert Pharmacies.get_location!(location.id) == location
    end

    test "create_location/1 with valid data creates a location", %{pharmacy: pharmacy} do
      assert {:ok, %Location{} = location} =
        @valid_attrs
        |> Map.put(:pharmacy_id, pharmacy.id)
        |> Pharmacies.create_location()
      assert location.latitude == "some latitude"
      assert location.longitude == "some longitude"
    end

    test "create_location/1 with invalid data returns error changeset", %{pharmacy: pharmacy} do
      assert {:error, %Ecto.Changeset{}} =
        @invalid_attrs
        |> Map.put(:pharmacy_id, pharmacy.id)
        |> Pharmacies.create_location()
    end

    test "create_location/1 without a pharmacy_id returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Pharmacies.create_location(@valid_attrs)
    end

    test "update_location/2 with valid data updates the location", %{pharmacy: pharmacy} do
      location = location_fixture(pharmacy_id: pharmacy.id)
      assert {:ok, %Location{} = location} = Pharmacies.update_location(location, @update_attrs)
      assert location.latitude == "some updated latitude"
      assert location.longitude == "some updated longitude"
    end

    test "update_location/2 with invalid data returns error changeset", %{pharmacy: pharmacy} do
      location = location_fixture(pharmacy_id: pharmacy.id)
      assert {:error, %Ecto.Changeset{}} = Pharmacies.update_location(location, @invalid_attrs)
      assert location == Pharmacies.get_location!(location.id)
    end

    test "delete_location/1 deletes the location", %{pharmacy: pharmacy} do
      location = location_fixture(pharmacy_id: pharmacy.id)
      assert {:ok, %Location{}} = Pharmacies.delete_location(location)
      assert_raise Ecto.NoResultsError, fn -> Pharmacies.get_location!(location.id) end
    end

    test "change_location/1 returns a location changeset", %{pharmacy: pharmacy} do
      location = location_fixture(pharmacy_id: pharmacy.id)
      assert %Ecto.Changeset{} = Pharmacies.change_location(location)
    end

    defp create_pharmacy(_) do
      {:ok, pharmacy: pharmacy_fixture(@pharmacy_attrs)}
    end
  end
end
