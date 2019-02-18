defmodule RxDeliveryWeb.PrescriptionController do
  use RxDeliveryWeb, :controller

  alias RxDelivery.Prescriptions
  alias RxDelivery.Prescriptions.Prescription

  def index(conn, _params) do
    prescriptions = Prescriptions.list_prescriptions()
    render(conn, "index.html", prescriptions: prescriptions)
  end

  def new(conn, _params) do
    changeset = Prescriptions.change_prescription(%Prescription{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"prescription" => prescription_params}) do
    case Prescriptions.create_prescription(prescription_params) do
      {:ok, prescription} ->
        conn
        |> put_flash(:info, "Prescription created successfully.")
        |> redirect(to: Routes.prescription_path(conn, :show, prescription))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    prescription = Prescriptions.get_prescription!(id)
    render(conn, "show.html", prescription: prescription)
  end

  def edit(conn, %{"id" => id}) do
    prescription = Prescriptions.get_prescription!(id)
    changeset = Prescriptions.change_prescription(prescription)
    render(conn, "edit.html", prescription: prescription, changeset: changeset)
  end

  def update(conn, %{"id" => id, "prescription" => prescription_params}) do
    prescription = Prescriptions.get_prescription!(id)

    case Prescriptions.update_prescription(prescription, prescription_params) do
      {:ok, prescription} ->
        conn
        |> put_flash(:info, "Prescription updated successfully.")
        |> redirect(to: Routes.prescription_path(conn, :show, prescription))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", prescription: prescription, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    prescription = Prescriptions.get_prescription!(id)
    {:ok, _prescription} = Prescriptions.delete_prescription(prescription)

    conn
    |> put_flash(:info, "Prescription deleted successfully.")
    |> redirect(to: Routes.prescription_path(conn, :index))
  end
end
