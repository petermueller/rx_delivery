# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     RxDelivery.Repo.insert!(%RxDelivery.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias RxDelivery.Pharmacies

[
  {%{name: "Alfa Pharmacy"},  %{latitude: "39.9612", longitude: "82.9988"}},
  {%{name: "Bravo Pharmacy"}, %{latitude: "40.9612", longitude: "72.9988"}},
]
|> Enum.map(fn {ph, loc} ->
  pharmacy = Pharmacies.create_pharmacy!(ph)

  loc
  |> Map.put(:pharmacy_id, pharmacy.id)
  |> Pharmacies.create_location!()
end)
