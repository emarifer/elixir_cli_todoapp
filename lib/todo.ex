defmodule Todo do
  alias Todo.{Helper, Tasks.Task}

  import IO.ANSI

  def run, do: loop()

  defp loop() do
    display_menu()

    case read_input() do
      "1" ->
        add()

      "2" ->
        list_items()

      "3" ->
        show_item()

      "4" ->
        find()

      "5" ->
        complete()

      "6" ->
        delete()

      "q" ->
        quit()

      _ ->
        Helper.show_error_message("Invalid option!")
        loop()
    end
  end

  defp display_menu do
    IO.puts("""
    \nTodo List App

    1. Add item
    2. List items
    3. Show item
    4. Search by terms in the title/description
    5. Complete/incomplete item
    6. Delete item
    q. Quit
    """)
  end

  defp read_input do
    IO.puts(format([:light_cyan, :bright, :italic, "Enter your choice:"]))
    IO.gets("") |> String.trim()
  end

  defp add do
    title = Helper.get_input_data("Enter title")
    description = Helper.get_input_data("Enter description")

    case Task.create_task(%{title: title, description: description}) do
      {:ok, _} ->
        IO.puts(format([:green, :bright, "\nTask added successfully!\n"]))
        loop()

      {:error, _} ->
        Helper.show_error_message(
          "Incorrectly filled fields: cannot be blank and the title must be 3-40 characters long!\n"
        )

        loop()
    end
  end

  defp list_items do
    case Task.get_all_tasks() do
      [] ->
        IO.puts(format([:light_magenta, :bright, "\nYou don't have any saved tasks yet.\n"]))
        loop()

      l ->
        Helper.display_list(l)
        loop()
    end
  end

  defp show_item do
    id =
      case Helper.get_input_data("Enter the task ID") |> Integer.parse() do
        {id, _} ->
          id

        :error ->
          Helper.show_error_message("The value entered is not a number!")
          loop()
      end

    case Task.get_task_by_id(id) do
      nil ->
        Helper.show_error_message("There is no task with that ID.")
        loop()

      task ->
        Helper.display_item(task)
        loop()
    end
  end

  defp find do
    list_found =
      Helper.get_input_data(
        "Enter a search term (e.g. 'my name') to find it in the title or description"
      )
      |> Task.search_by_terms()

    case list_found do
      [] ->
        IO.puts(format([:light_magenta, :bright, "\nNothing found with those search terms.\n"]))
        loop()

      l ->
        Enum.each(l, &Helper.display_item/1)
        # Helper.display_list(l)
        loop()
    end
  end

  defp complete do
    id =
      case Helper.get_input_data("Enter the task ID") |> Integer.parse() do
        {id, _} ->
          id

        :error ->
          Helper.show_error_message("The value entered is not a number!")
          loop()
      end

    case Task.update_task_by_id(id) do
      {:ok, _} ->
        IO.puts(format([:green, :bright, "\nTask updated successfully!\n"]))
        loop()

      {:error, reason} ->
        Helper.show_error_message(
          "An error occurred while trying to update the task. Reason: #{reason}"
        )

        loop()
    end
  end

  defp delete do
    id =
      case Helper.get_input_data("Enter the task ID") |> Integer.parse() do
        {id, _} ->
          id

        :error ->
          Helper.show_error_message("The value entered is not a number!")
          loop()
      end

    case Helper.get_input_data("Are you sure? [y/n]", color: :warning) do
      "y" ->
        case Task.delete_task_by_id(id) do
          {:ok, _} ->
            IO.puts(format([:green, :bright, "\nTask successfully deleted!\n"]))
            loop()

          {:error, reason} ->
            Helper.show_error_message(
              "An error occurred while trying to delete the task. Reason: #{reason}"
            )

            loop()
        end

      _ ->
        loop()
    end
  end

  @dialyzer {:nowarn_function, quit: 0}
  defp quit do
    IO.puts(IO.ANSI.format([:light_magenta, "\nGoodbye!"]))

    System.halt()
  end
end

# REFERENCES:
# https://www.jonathanychan.com/blog/statically-linking-an-elixir-command-line-application-using-burrito/
# https://akhil.sh/tutorials/elixir/elixir/03_cli_tool_using_elixir/
# https://brewingelixir.com/cli-apps-in-elixir-part-1
# https://brewingelixir.com/cli-apps-in-elixir-part-2?source=more_series_bottom_blogs
# https://dennisbeatty.com/cool-clis-in-elixir-part-2-with-io-ansi/
