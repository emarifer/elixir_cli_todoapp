defmodule Mix.Tasks.App.Installer do
  use Mix.Task

  @impl Mix.Task
  def run(_command_line_args) do
    home = System.user_home()
    app_path = Path.join([home, ".local/bin/"])

    Mix.env(:prod)
    Mix.Task.run("release")

    Mix.Shell.cmd("cp ./burrito_out/todo_cli_app_linux #{app_path}/", &IO.write(&1))

    Mix.Shell.cmd("mv #{app_path}/todo_cli_app_linux #{app_path}/todo_cli_app", &IO.write(&1))

    filewriter("\nexport PATH=$PATH:$HOME/.local/bin/todo_cli_app", "#{home}/.bashrc")

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
