defmodule Todo.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: Todo.Worker.start_link(arg)
      # {Todo.Worker, arg}
      {
        Ecto.Migrator,
        repos: Application.fetch_env!(:todo, :ecto_repos), skip: false
      },
      Todo.Repo,
      # {Task.Supervisor, name: Todo.TaskSupervisor},
      # Supervisor.child_spec({Task, fn -> Todo.run() end}, restart: :temporary)
      {Task, &Todo.run/0}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Todo.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

# REFERENCES:
# https://www.jonathanychan.com/blog/statically-linking-an-elixir-command-line-application-using-burrito/
