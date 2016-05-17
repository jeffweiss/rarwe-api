ExUnit.start

Mix.Task.run "ecto.create", ~w(-r Rarwe.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r Rarwe.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(Rarwe.Repo)

