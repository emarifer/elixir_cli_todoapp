import Config

if config_env() == :prod do
  #   database_path =
  #     System.get_env("DATABASE_PATH") ||
  #       raise """
  #       environment variable DATABASE_PATH is missing.
  #       For example: /etc/todo_app/todo_app.db
  #       """

  config :todo, Todo.Repo,
    # database: database_path,
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "5")
end
