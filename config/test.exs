import Config

# Only in tests, remove the complexity from the password hashing algorithm
config :bcrypt_elixir, :log_rounds, 1

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :lipia_ngoma, LipiaNgoma.Repo,
  username: "root",
  password: "",
  hostname: "localhost",
  database: "lipia_ngoma_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :lipia_ngoma, LipiaNgomaWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "6KxubscUZfLFDeFnDpmcav+2F5xt3ruXw90JrfQnWJjAHSETR/Fx3JWs8vjWdppf",
  server: false

# In test we don't send emails.
config :lipia_ngoma, LipiaNgoma.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
