defmodule Mix.Tasks.App.Installer do
  use Mix.Task

  @impl Mix.Task
  def run(_command_line_args) do
    Mix.env(:prod)
    Mix.Task.run("release")

    Mix.Shell.cmd("_build/prod/rel/todo/bin/todo eval 'Todo.Release.migrate'", &IO.write(&1))

    home = System.user_home()
    app_path = Path.join([System.user_home(), ".local/bin/", "todo/bin/todo"])

    run_content = """
    #!/bin/bash

    exec #{app_path} start
    """

    File.write!("_build/prod/rel/todo/todo", run_content)
    File.chmod("_build/prod/rel/todo/todo", 0o777)

    File.cp_r("_build/prod/rel/", Path.join([home, ".local/bin/"]))

    filewriter("\nexport PATH=$PATH:$HOME/.local/bin/todo/", "#{home}/.bashrc")

    Mix.Shell.cmd(". #{home}/.bashrc", &IO.write(&1))

    IO.puts(
      IO.ANSI.format([
        :green,
        :bright,
        "\nThe application has been successfully installed on your system!!"
      ])
    )
  end

  def filewriter(data, filename) do
    filename
    |> File.open!([:write, :append])
    |> IO.binwrite(data)
  end
end

# REFERENCES:
# https://stackoverflow.com/questions/37461981/what-is-the-best-approach-to-append-to-a-file-in-elixir
# https://stackoverflow.com/questions/74796187/appending-lines-to-a-file-whose-path-is-defined-in-an-environment-variable
# https://stackoverflow.com/questions/13702425/source-command-not-found-in-sh-shell
