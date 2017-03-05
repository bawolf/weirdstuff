use Mix.Config

# In this file, we keep production configuration that
# you likely want to automate and keep it away from
# your version control system.
#
# You should document the content of this
# file or create a script for recreating it, since it's
# kept out of version control and might be hard to recover
# or recreate for your teammates (or you later on).
config :weird_stuff, WeirdStuff.Endpoint,
  secret_key_base: "hk9ApCAKwMVeZzITmwAYiadRhrWd4UYm+tpdUwVzJSwtV5iBSIZ8x0jFGyezCEUN"

# Configure your database
config :weird_stuff, WeirdStuff.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "weird_stuff_prod",
  pool_size: 20
