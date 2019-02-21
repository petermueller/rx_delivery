defmodule RxDeliveryWeb.Router do
  use RxDeliveryWeb, :router

  import RxDeliveryWeb.Helpers.Auth,
    only: [load_current_pharmacy: 2]

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :load_current_pharmacy
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", RxDeliveryWeb do
    pipe_through :browser

    get "/", PageController, :index

    get "/sign-in", SessionController, :new
    post "/sign-in", SessionController, :create
    delete "/sign-out", SessionController, :delete

    resources "/registrations", PharmacyController, only: [:new, :create]
    resources "/pharmacies", PharmacyController, only: [:index, :show] do
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
