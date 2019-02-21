defmodule RxDeliveryWeb.SessionController do
  use RxDeliveryWeb, :controller
  alias RxDelivery.Pharmacies

  def new(conn, _params), do: render(conn, "new.html")

  def create(conn, %{"session" => auth_params}) do
    pharmacy = Pharmacies.get_pharmacy_by_username(auth_params["username"])

    case Bcrypt.check_pass(pharmacy, auth_params["password"]) do
      {:ok, pharmacy} ->
        conn
        |> Auth.signin!(pharmacy)
        |> put_flash(:info, "Signed in.")
        |> redirect(to: Routes.page_path(conn, :index))
      {:error, _} ->
        conn
        |> put_flash(:error, "There was an issue with your username/password.")
        |> render("new.html")
    end
  end

  def delete(conn, _params) do
    conn
    |> Auth.signout!()
    |> put_flash(:info, "Signed out.")
    |> redirect(to: Routes.page_path(conn, :index))
  end
end
