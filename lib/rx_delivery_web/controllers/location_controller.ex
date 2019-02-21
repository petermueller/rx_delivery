defmodule RxDeliveryWeb.LocationController do
  use RxDeliveryWeb, :controller

  alias RxDelivery.Pharmacies
  alias RxDelivery.Pharmacies.Location

  plug :set_pharmacy_assigns
  plug :authorize_current_pharmacy

  # Actions

  def new(conn, _params) do
    pharmacy = conn.assigns.pharmacy
    case pharmacy.location do
      nil ->
        changeset = Pharmacies.change_location(%Location{})
        render(conn, "new.html", changeset: changeset)
      _location ->
        conn
        |> put_flash(:info, "Location already set.")
        |> redirect(to: Routes.pharmacy_location_path(conn, :show, pharmacy))
    end
  end

  def create(conn, %{"location" => location_params}) do
    pharmacy = conn.assigns.pharmacy
    case Pharmacies.create_location(Map.put(location_params, "pharmacy_id", pharmacy.id)) do
      {:ok, _location} ->
        conn
        |> put_flash(:info, "Location created successfully.")
        |> redirect(to: Routes.pharmacy_location_path(conn, :show, pharmacy))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, _params) do
    pharmacy = conn.assigns.pharmacy
    case pharmacy.location do
      nil -> redirect_to_new_location(conn, "No location set.")
      location -> render(conn, "show.html", location: location)
    end
  end

  def edit(conn, _params) do
    pharmacy = conn.assigns.pharmacy
    case pharmacy.location do
      nil -> redirect_to_new_location(conn, "No location set.")
      location ->
        changeset = Pharmacies.change_location(location)
        render(conn, "edit.html", location: location, changeset: changeset)
    end
  end

  def update(conn, %{"location" => location_params}) do
    pharmacy = conn.assigns.pharmacy
    with(
      {:ok, location} <- Map.fetch(pharmacy, :location),
      {:ok, _updated_location} <- Pharmacies.update_location(location, location_params)
    ) do
      conn
      |> put_flash(:info, "Location updated successfully.")
      |> redirect(to: Routes.pharmacy_location_path(conn, :show, pharmacy))
    else
      :error -> redirect_to_new_location(conn, "No location set.")
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", location: pharmacy.location, changeset: changeset)
    end
  end

  def delete(conn, _params) do
    pharmacy = conn.assigns.pharmacy
    case pharmacy.location do
      nil -> redirect_to_new_location(conn, "No location set.")
      location ->
        {:ok, _location} = Pharmacies.delete_location(location)

        redirect_to_new_location(conn, "Location deleted successfully.")
    end
  end

  # Private

  defp set_pharmacy_assigns(conn, _) do
    %{"pharmacy_id" => pharmacy_id} = conn.params

    case Pharmacies.get_pharmacy(pharmacy_id, with: :location) do
      nil -> render_not_found(conn)
      pharmacy -> assign(conn, :pharmacy, pharmacy)
    end
  end

  defp authorize_current_pharmacy(conn, _) do
    if is_authorized_for_action?(conn, action_name(conn)) do
      conn
    else
      conn
      |> put_flash(:error, "Forbidden")
      |> redirect(to: Routes.pharmacy_path(conn, :show, Auth.current_pharmacy(conn)))
      |> halt()
    end
  end

  defp is_authorized_for_action?(_conn, :show), do: true
  defp is_authorized_for_action?(conn, _action) do
    %{id: current_pharmacy_id} = Auth.current_pharmacy(conn)
    %{id: pharmacy_id} = conn.assigns.pharmacy

    current_pharmacy_id == pharmacy_id
  end

  defp redirect_to_new_location(conn, message) do
    conn
    |> put_flash(:info, message)
    |> redirect_to_new_location()
  end
  defp redirect_to_new_location(conn) do
    conn
    |> redirect(to: Routes.pharmacy_location_path(conn, :new, conn.assigns.pharmacy))
  end

  defp render_not_found(conn) do
    conn
    |> put_status(:not_found)
    |> put_view(RxDeliveryWeb.ErrorView)
    |> render("404.html")
    |> halt()
  end
end
