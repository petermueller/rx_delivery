defmodule RxDelivery.PatientsTest do
  use RxDelivery.DataCase

  alias RxDelivery.Patients
  alias RxDelivery.Prescriptions
  alias RxDelivery.Pharmacies

  alias RxDelivery.Fixtures

  describe "patients" do
    alias RxDelivery.Patients.Patient

    @valid_attrs %{first_name: "some first_name", last_name: "some last_name"}
    @update_attrs %{first_name: "some updated first_name", last_name: "some updated last_name"}
    @invalid_attrs %{first_name: nil, last_name: nil}

    def patient_fixture(attrs \\ %{}) do
      {:ok, patient} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Patients.create_patient()

      patient
    end

    test "list_patients/0 returns all patients" do
      patient = patient_fixture()
      assert Patients.list_patients() == [patient]
    end

    test "get_patient!/1 returns the patient with given id" do
      patient = patient_fixture()
      assert Patients.get_patient!(patient.id) == patient
    end

    test "create_patient/1 with valid data creates a patient" do
      assert {:ok, %Patient{} = patient} = Patients.create_patient(@valid_attrs)
      assert patient.first_name == "some first_name"
      assert patient.last_name == "some last_name"
    end

    test "create_patient/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Patients.create_patient(@invalid_attrs)
    end

    test "update_patient/2 with valid data updates the patient" do
      patient = patient_fixture()
      assert {:ok, %Patient{} = patient} = Patients.update_patient(patient, @update_attrs)
      assert patient.first_name == "some updated first_name"
      assert patient.last_name == "some updated last_name"
    end

    test "update_patient/2 with invalid data returns error changeset" do
      patient = patient_fixture()
      assert {:error, %Ecto.Changeset{}} = Patients.update_patient(patient, @invalid_attrs)
      assert patient == Patients.get_patient!(patient.id)
    end

    test "delete_patient/1 deletes the patient" do
      patient = patient_fixture()
      assert {:ok, %Patient{}} = Patients.delete_patient(patient)
      assert_raise Ecto.NoResultsError, fn -> Patients.get_patient!(patient.id) end
    end

    test "change_patient/1 returns a patient changeset" do
      patient = patient_fixture()
      assert %Ecto.Changeset{} = Patients.change_patient(patient)
    end
  end

  describe "orders" do
    alias RxDelivery.Patients.Order

    @invalid_attrs %{
      patient_id:      10_000,
      prescription_id: 10_000,
      location_id:     10_000,
    }

    def order_fixture(attrs \\ Fixtures.order_attrs()), do: Patients.create_order!(attrs)

    test "list_orders/0 returns all orders" do
      order = order_fixture()
      assert Patients.list_orders() == [order]
    end

    test "get_order!/1 returns the order with given id" do
      order = order_fixture()
      assert Patients.get_order!(order.id) == order
    end

    test "create_order/1 with valid data creates a order" do
      assert {:ok, %Order{} = order} = Patients.create_order(Fixtures.order_attrs())
    end

    test "create_order!/1 with invalid data returns error changeset" do
      assert_raise Ecto.InvalidChangesetError, fn -> Patients.create_order!(@invalid_attrs) end
    end

    test "create_order/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Patients.create_order(@invalid_attrs)
    end

    test "update_order/2 with valid data updates the order" do
      order = order_fixture()
      updated_order_attrs =
        Fixtures.order_attrs(
          %{location_attrs: %{pharmacy_id: Fixtures.updated_pharmacy().id}}
        )
      assert {:ok, %Order{} = order} = Patients.update_order(order, updated_order_attrs)
    end

    test "update_order/2 with invalid data returns error changeset" do
      order = order_fixture()
      assert {:error, %Ecto.Changeset{}} = Patients.update_order(order, @invalid_attrs)
      assert order == Patients.get_order!(order.id)
    end

    test "delete_order/1 deletes the order" do
      order = order_fixture()
      assert {:ok, %Order{}} = Patients.delete_order(order)
      assert_raise Ecto.NoResultsError, fn -> Patients.get_order!(order.id) end
    end

    test "change_order/1 returns a order changeset" do
      order = order_fixture()
      assert %Ecto.Changeset{} = Patients.change_order(order)
    end
  end
end
