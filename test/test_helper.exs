ExUnit.start()

Code.require_file "./support/schema.exs", __DIR__
Code.require_file "./support/repo.exs", __DIR__
Code.require_file "./support/migrations.exs", __DIR__
Code.require_file "./support/conn_case.exs", __DIR__

defmodule Coherence.RepoSetup do
  use ExUnit.CaseTemplate
end

TestNoegle.Repo.__adapter__.storage_down TestNoegle.Repo.config
TestNoegle.Repo.__adapter__.storage_up TestNoegle.Repo.config

{:ok, _pid} = TestNoegle.Repo.start_link
_ = Ecto.Migrator.up(TestNoegle.Repo, 0, TestNoegle.Migrations, log: false)
Process.flag(:trap_exit, true)
Ecto.Adapters.SQL.Sandbox.mode(TestNoegle.Repo, :manual)
