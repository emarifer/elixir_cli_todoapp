defmodule Todo.MixProject do
  use Mix.Project

  def project do
    [
      app: :todo,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
      # releases: releases()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Todo.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:burrito, "~> 1.3"},
      {:ecto_sql, "~> 3.13"},
      {:ecto_sqlite3, "~> 0.21.0"},
      {:timex, "~> 3.7"}
      # {:tzdata, "~> 1.1"}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup"],
      "ecto.setup": ["ecto.create", "ecto.migrate"],
      "ecto.reset": ["ecto.drop", "ecto.setup"]
    ]
  end

  # defp releases do
  #   [
  #     todo_cli_app: [
  #       steps: [:assemble, &Burrito.wrap/1],
  #       burrito: [
  #         targets: [
  #           linux: [os: :linux, cpu: :x86_64],
  #           # macos: [os: :darwin, cpu: :x86_64]
  #           windows: [os: :windows, cpu: :x86_64]
  #         ]
  #       ]
  #     ]
  #   ]
  # end
end

# REFERENCES:
# https://www.jonathanychan.com/blog/statically-linking-an-elixir-command-line-application-using-burrito/

# COMMANDS TO CREATE RELEASE (GitHub):
# git tag v0.1.0 && git push origin v0.1.0
# zip -9r todo_cli_app_windows_x86_64.zip *.txt dist/
# https://blog.robertelder.org/intro-to-sha256sum-command/
# sha256sum todo_cli_app_windows_x86_64.zip ==>
# fdae2d396e7741e94b898756a46f210e24e21adb3eae353dc72e63da1daad75a
# echo "fdae2d396e7741e94b898756a46f210e24e21adb3eae353dc72e63da1daad75a todo_cli_app_windows_x86_64.zip" | sha256sum -c
# https://askubuntu.com/questions/1202208/checking-sha256-checksum
# # Create the .tar.xz file
# tar -czvf todo_cli_app_linux_x86_64.tar.xz usr/ LICENSE.txt
# sha256sum todo_cli_app_linux_x86_64.tar.xz ==>
# e10b3af27f7d6846de6b81dd86db9d2143882eca1de8c7beb6f0355ade74eb1b
# sha256sum *zip *tar.xz > sha256sums.txt (create .txt file)
# sha256sum -c sha256sums.txt (check .txt file)
