use Mix.Config
config :comeonin, bcrypt_log_rounds: 3

config :logger, level: :warn

config :noegle, TestNoegle.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "coherence_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
