{:ok, _} = Application.ensure_all_started(:mox)
ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(Expi.Repo, :manual)

# MOX
Mox.defmock(Expi.Github.ClientMock, for: Expi.Github.Behaviour)
