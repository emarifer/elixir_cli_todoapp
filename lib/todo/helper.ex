defmodule Todo.Helper do
  alias Todo.Tasks.Task

  import IO.ANSI

  @lim_title 19
  @lim_descr 21

  def display_list(list) do
    cols =
      for %Task{title: t, description: d, updated_at: u} <- list do
        [
          String.length(t) |> max_len_item(@lim_title),
          String.length(d) |> max_len_item(@lim_descr),
          String.length(convert_datetime(u))
        ]
      end

    widths =
      Enum.zip(cols)
      |> Enum.map(&Tuple.to_list/1)
      |> Enum.map(&(Enum.max(&1) + 2))
      |> Enum.map(&if &1 < 13, do: 13, else: &1)
      |> List.to_tuple()

    line =
      (~c"-" |> List.duplicate(6)) ++
        ~c"+" ++
        (~c"-" |> List.duplicate(elem(widths, 0))) ++
        ~c"+" ++
        (~c"-" |> List.duplicate(elem(widths, 1))) ++
        ~c"+" ++
        (~c"-" |> List.duplicate(elem(widths, 2))) ++
        ~c"+" ++
        (~c"-" |> List.duplicate(6))

    delimiter = ~c"=" |> List.duplicate(Enum.sum(Tuple.to_list(widths)) + 4 + 6 + 6)

    header =
      (~c"ID" |> center(6)) ++
        ~c"|" ++
        (~c"Title" |> center(elem(widths, 0))) ++
        ~c"|" ++
        (~c"Description" |> center(elem(widths, 1))) ++
        ~c"|" ++
        (~c"Updated At" |> center(elem(widths, 2))) ++
        ~c"|" ++
        (~c"Done" |> center(6))

    IO.puts(format([:yellow, :bright, :underline, "\nTodo List:\n"]))
    IO.puts(IO.ANSI.format([:cyan, :bright, delimiter]))
    IO.puts(IO.ANSI.format([:yellow, :bright, header]))
    IO.puts(IO.ANSI.format([:yellow, :bright, line]))

    for %Task{id: i, title: t, description: d, updated_at: u, done: c} <- list do
      i = Integer.to_charlist(i) |> center(6)
      t = String.to_charlist(t) |> max_len_item(@lim_title) |> center(elem(widths, 0))
      d = String.to_charlist(d) |> max_len_item(@lim_descr) |> center(elem(widths, 1))
      u = String.to_charlist(convert_datetime(u)) |> center(elem(widths, 2))
      c = if(c, do: [9989], else: [10060]) |> center(6)

      IO.puts(i ++ ~c"|" ++ t ++ ~c"|" ++ d ++ ~c"|" ++ u ++ ~c"|" ++ c)
      IO.puts(line)
    end

    IO.puts(IO.ANSI.format([:cyan, :bright, delimiter]))
    IO.puts("\n")
  end

  def display_item(
        %Task{
          id: id,
          title: t,
          description: d,
          updated_at: u,
          inserted_at: i,
          done: c
        } = _task
      ) do
    delimiter =
      ~c"="
      |> List.duplicate(
        [id, t, d, convert_datetime(u), convert_datetime(i)]
        |> Stream.map(&(length(to_charlist(&1)) + 16))
        |> Enum.max()
      )

    IO.puts(format([:yellow, :bright, :underline, "\nShow task with id ##{id}:\n"]))

    IO.puts(IO.ANSI.format([:cyan, :bright, delimiter]))
    IO.write(format([:light_yellow, :bright, "• Title: "]))
    IO.puts(format([:light_black_background, :bright, t]))
    IO.write(format([:light_yellow, :bright, "• Description: "]))
    IO.puts(format([:light_black_background, :bright, d]))
    IO.write(format([:light_yellow, :bright, "• Updated At: "]))
    IO.puts(format([:light_black_background, :bright, convert_datetime(u)]))
    IO.write(format([:light_yellow, :bright, "• Inserted At: "]))
    IO.puts(format([:light_black_background, :bright, convert_datetime(i)]))
    IO.write(format([:light_yellow, :bright, "• Completed: "]))
    IO.puts(if(c, do: "✅", else: "❌"))
    IO.puts(IO.ANSI.format([:cyan, :bright, delimiter]))
  end

  def get_input_data(request, opts \\ []) when is_list(opts) do
    color = Keyword.get(opts, :color, :light_blue)

    IO.puts(
      format([if(color == :warning, do: color(5, 2, 0), else: color), :bright, "\n#{request}:"])
    )

    data = IO.gets(light_blue_background() <> "") |> String.trim()

    reset()
    |> Kernel.<>(clear_line())
    |> IO.write()

    data
  end

  def show_error_message(msg) do
    IO.puts(format([:light_red, :bright, "\n#{msg}"]))
  end

  def convert_datetime(dt) do
    # Only works on Linux:
    # {zone, result} = System.shell("timedatectl | grep 'Time zone' | awk '{print $3}'")
    # tzone = if result == 0, do: String.trim(zone)

    tzone = Timex.Timezone.Local.lookup()

    # {:ok, local_datetime} = DateTime.shift_zone(dt, tzone)
    # {RFC1123} #==> Tue, 05 Mar 2013 23:25:19 +0200
    {:ok, local_datetime} =
      Timex.to_datetime(dt, tzone) |> Timex.Format.DateTime.Formatter.format("{RFC1123}")

    local_datetime
  end

  # defp center(chars, width, c \\ ?\s) when length(chars) < width
  defp center(chars, width, c \\ ?\s) do
    fill = width - length(chars)

    s = List.duplicate(c, div(fill, 2))
    a = List.duplicate(c, rem(fill, 2))
    s ++ chars ++ s ++ a
  end

  defp max_len_item(item, lim) when is_list(item) do
    if length(item) > lim, do: Enum.take(item, lim - 1) ++ ~c"…", else: item
  end

  defp max_len_item(item, lim) when is_integer(item) do
    if item > lim, do: Enum.min([item, lim - 1]), else: item
  end
end

# REFERENCES:
# https://dennisbeatty.com/cool-clis-in-elixir-part-2-with-io-ansi/
#
# https://elixirforum.com/t/transpose-a-list-of-lists-using-list-comprehension/17638/3
#
# https://elixirforum.com/t/determining-the-current-system-timezone/34688/11
# System.shell("timedatectl | grep 'Time zone' | awk '{print $3}'")
