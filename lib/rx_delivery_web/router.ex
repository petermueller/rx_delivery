defmodule RxDeliveryWeb.Router do
  use RxDeliveryWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", RxDeliveryWeb do
    pipe_through :browser

    get "/", PageController, :index
    resources "/pharmacies", PharmacyController do
      resources "/location", LocationController, singleton: true
    end
    resources "/orders", OrderController
    resources "/patients", PatientController
    resources "/prescriptions", PrescriptionController
  end

  # Other scopes may use custom stacks.
  # scope "/api", RxDeliveryWeb do
  #   pipe_through :api
  # end
end
