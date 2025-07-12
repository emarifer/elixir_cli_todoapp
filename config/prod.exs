import Config

# Configure your database
db_path = Path.join([System.user_home(), ".config", "todo_cli_app"])

config :todo, Todo.Repo,
  database: Path.join(db_path, "/database.sqlite3"),
  pool_size: 5

# Do not print debug messages in production
config :logger, level: :info
