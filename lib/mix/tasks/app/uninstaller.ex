defmodule Mix.Tasks.App.Uninstaller do
  use Mix.Task

  alias Mix.Tasks.App.Installer

  @impl Mix.Task
  def run(_command_line_args) do
    home = System.user_home()
    app_path = Path.join([home, ".local/bin/todo"])
    db_path = Path.join([home, ".config", "todo"])

    File.rm_rf!(app_path)
    File.rm_rf!(db_path)
    File.rm_rf!("_build/prod")

    File.read!("#{home}/.bashrc")
    |> String.split("\n")
    |> Enum.filter(&(&1 != "export PATH=$PATH:$HOME/.local/bin/todo/"))
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
