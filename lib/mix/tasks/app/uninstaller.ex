defmodule Mix.Tasks.App.Uninstaller do
  use Mix.Task

  alias Mix.Tasks.App.Installer

  @impl Mix.Task
  def run(_command_line_args) do
    home = System.user_home()
    app_path = Path.join([home, ".local/bin/todo_cli_app"])
    db_path = Path.join([home, ".config", "todo_cli_app"])

    erts_folder_path =
      Path.wildcard(Path.join([home, ".local/share/.burrito/", "todo_cli_app_*"]))

    File.rm_rf!(app_path)
    File.rm_rf!(db_path)
    File.rm_rf!(erts_folder_path)

    File.read!("#{home}/.bashrc")
    |> String.split("\n")
    |> Enum.filter(&(&1 != "export PATH=$PATH:$HOME/.local/bin/todo_cli_app"))
    |> Enum.join("\n")
    |> Installer.filewriter("#{home}/.bashrc.new")

    Mix.Shell.cmd("mv #{home}/.bashrc.new #{home}/.bashrc", &IO.write(&1))

    Mix.Shell.cmd(". #{home}/.bashrc", &IO.write(&1))

    IO.puts(
      IO.ANSI.format([
        :cyan,
        :bright,
        "\nThe application has been successfully removed from your system."
      ])
    )
  end
end

# REFERENCES:
# https://elixirforum.com/t/how-to-delete-a-line-in-a-file/42608
