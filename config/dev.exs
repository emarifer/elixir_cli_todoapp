import Config

# Configure your database
config :todo, Todo.Repo,
  database: Path.expand("../todo_dev.db", __DIR__),
  pool_size: 5,
  stacktrace: true,
  show_sensitive_data_on_connection_error: true
