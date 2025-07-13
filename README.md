<div align="center">

# Elixir CLI Todoapp

### Example CLI to-do list application written in Elixir with SQLite3 database persistence.

<br /><br />

> 🚧 This is a work in progress and therefore you should expect that the
> application may not have all the features at this moment.

<br />
  
![GitHub License](https://img.shields.io/github/license/emarifer/elixir_cli_todoapp) ![Static Badge](https://img.shields.io/badge/Elixir-%3E=1.18-6e4a7e) ![Static Badge](https://img.shields.io/badge/Erlang/OTP-%3E=27-B83998)

</div>

<hr />

### Features 🚀:

Elixir is an incredibly robust and elegant programming language. It excels above many other languages in the reliability of its solutions, fault tolerance (typical of languages running on the BEAM VM), distributed computing, and, above all, the ease and reliability with which concurrent systems are built.

Elixir is designed to do a lot of things really well but it’s hard to beat languages that were designed specifically to be good for `CLI tools` without trading off the things that make it great for all other stuff. Languages like `Rust`, `Zig`, and especially `Go`, due to their ease of use (remember that the powerful Docker CLI and the Docker system itself are written in Go), are more suitable for creating CLI tools. However, when building CLI tools with Elixir, you'll rarely need to use its powerful features and will instead have to deal with the occasional inconvenience.

Among other things, we can mention the boot times required by Elixir applications, given that the `BEAM virtual machine` must be started (between 200 and 500 ms, depending on the machine it's running on). If the application is used as a simple interactive tool, this isn't a problem, but if it's used as a looped command within a shell script, this boot time would be an unacceptable hindrance.

The other problem is the lower portability resulting from compilation artifacts. With the aforementioned languages, we get a single executable and, in the case of Go, very easy cross-compilation for various operating systems. With Elixir, we have several options, each with its pros and cons. With Elixir releases, we get a folder that includes not only the compiled code but also the `Erlang virtual machine` and its default execution environment, so they do not need to be installed on the host where the application is run. However, this solution works better with [`daemons`](https://en.wikipedia.org/wiki/Daemon_(computing)) than with foreground CLI applications. They can only run on the same OS and with the same version as the one on which they were compiled, and they are not a single executable but a folder. [`Mix Escript`](https://hexdocs.pm/mix/1.18.4/Mix.Tasks.Escript.Build.html) does provide a single, lighter executable but requires the host to have `Erlang/OTP` installed. This looks perfect but it has one downside: it doesn't support projects or dependencies that need to store or read from the `priv` directory, as is the case of the [`tzdata`](https://github.com/lau/tzdata) library, which we use in this project as a dependency of another library, `Timex` (it connects to the Internet at startup and downloads the time zone update from the [`IANA tz database`](https://www.iana.org/time-zones)).

Fortunately, to overcome most if not all limitations, and be able to produce a single binary artifact, there's a fantastic OSS library called `Burrito` (which we'll cover next). It lets you wrap your meaty app so you can delight your CLI app users!

There are many situations in which a CLI application written in Elixir will not suffer the aforementioned drawbacks, mainly in the case of interactive tools that perform tasks that can be tedious or useful for a user, as in the case of this application, which, in any case, is oriented towards learning this fantastic language that is Elixir 😀.


- [x] **Using the [Burrito](https://github.com/burrito-elixir/burrito) library:** As stated in `Burrito`s own documentation: "Burrito is our answer to the problem of distributing Elixir CLI applications across varied environments, where we cannot guarantee that the Erlang runtime is installed, and where we lack the permissions to install it ourselves". Burrito uses [`Mix releases`](https://hexdocs.pm/mix/1.18.4/Mix.Tasks.Release.html) so we get all their benefits as well as a self-extracting archive. It creates a native binary for `macOS`, `Linux`, and `Windows`. It is very configurable and allows `cross-compilation` with almost no restrictions 😀. Consequently, the resulting binary is distributable, and neither Elixir nor Erlang/OTP is required. When you run it for the first time, a folder containing the `ERTS` ([`Erlang Runtime System Application`](https://www.erlang.org/doc/apps/erts/introduction.html)) and the BEAM virtual machine is automatically installed in the OS configuration folder.


- [x] **Using the [Timex](https://hexdocs.pm/timex/Timex.html) library:** We've already mentioned that this library uses `tzdata` under the hood, and we use it to make it easier to use time zones and format dates and times. `Ecto` (see below), by default, utilizes [`NaiveDateTime`](https://hexdocs.pm/elixir/NaiveDateTime.html) for `timestamps` in `migrations` and `schemas`. When using `timestamps()` in an `Ecto schema`, it generates two fields: `inserted_at` and `updated_at`. These fields default to using the naive_datetime type. If, on the other hand, we tell Ecto to store the timestamps with the `utc_datetime` type, this will save the `UTC time` in the database but will internally record the local time zone, which we can later "translate" into the time zone of the host running the application. All of this is probably unnecessary in an application like this, but it would make the database `SQLite` file more portable and, above all, allow us to learn how to use a new library 😅.


- [x] **Using the [Ecto](https://hexdocs.pm/ecto/3.13.2/Ecto.html) library:** Ecto (an official Elixir project) is a database wrapper and [`query language`]() for the Elixir programming language. It provides a way to interact with SQL databases, manage data, and build queries using Elixir syntax. Ecto is not an [`ORM`](https://en.wikipedia.org/wiki/Object%E2%80%93relational_mapping) (Object-Relational Mapper) in the traditional sense, as it doesn't automatically track changes to data like some ORMs do. Instead, it focuses on providing a flexible and powerful way to interact with databases while giving developers more control over data management. With Ecto we’re able to create migrations, define schemas, insert and update records, and query them. Although Ecto recommends using `PostgreSQL`, for a CLI project it is more appropriate to use [`SQLite3`](https://www.sqlite.org/)

- [x] **Finally, the application itself:** is configured around a recursive [loop](https://github.com/emarifer/elixir_cli_todoapp/blob/main/lib/todo.ex) that waits indefinitely for the user to enter a choice and responds accordingly. When the application starts (in the `Application.start/2` callback), this function is called as a [`Task process`](https://hexdocs.pm/elixir/Task.html) within the application's supervisor tree. It ends when the user chooses the `quit` option, which calls `System.halt/1`. For this recursive loop we were inspired by these publications:
    - [Statically linking an Elixir command-line application using Burrito](https://www.jonathanychan.com/blog/statically-linking-an-elixir-command-line-application-using-burrito/)
    - [Build a CLI Todo List using Elixir](https://akhil.sh/tutorials/elixir/elixir/03_cli_tool_using_elixir/)

### Getting Started 👨‍🚀:

### Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `todo` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:todo, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/todo>.

---

### Happy coding 😀!!