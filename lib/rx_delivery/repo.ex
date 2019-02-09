defmodule RxDelivery.Repo do
  use Ecto.Repo,
    otp_app: :rx_delivery,
    adapter: Ecto.Adapters.Postgres
end
