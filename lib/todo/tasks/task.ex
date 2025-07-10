defmodule Todo.Tasks.Task do
  use Ecto.Schema
  import Ecto.{Changeset, Query}

  schema "tasks" do
    field :done, :boolean, default: false
    field :description, :string
    field :title, :string

    timestamps(type: :utc_datetime)
  end

  @min_chars 3
  @max_chars 40

  @doc false
  defp changeset(todo, attrs) do
    todo
    |> cast(attrs, [:title, :description, :done])
    |> validate_required([:title, :description, :done])
    |> validate_length(:title, min: @min_chars, max: @max_chars)
  end

  def create_task(attrs \\ %{}) do
    %Todo.Tasks.Task{}
    |> changeset(attrs)
    |> Todo.Repo.insert()
  end

  def get_all_tasks do
    Todo.Tasks.Task
    |> order_by(desc: :updated_at)
    |> Todo.Repo.all()
  end

  def get_task_by_id(id), do: Todo.Repo.get(Todo.Tasks.Task, id)

  def search_by_terms(search_term) do
    Todo.Tasks.Task
    |> where(
      [t],
      like(t.title, ^"%#{search_term}%") or like(t.description, ^"%#{search_term}%")
    )
    |> order_by(desc: :updated_at)
    |> Todo.Repo.all()
  end

  def delete_task_by_id(id) do
    with {:ok, task} <- get_by_id(id),
         {:ok, task} <- Todo.Repo.delete(task) do
      {:ok, task}
    end
  end

  def update_task_by_id(id) do
    with {:ok, task} <- get_by_id(id),
         {:ok, task} <- changeset(task, %{"done" => !task.done}) |> Todo.Repo.update() do
      {:ok, task}
    end
  end

  # Normalizes the error response
  defp get_by_id(id) do
    case Todo.Repo.get(Todo.Tasks.Task, id) do
      nil -> {:error, "incorrect id"}
      %Todo.Tasks.Task{} = task -> {:ok, task}
    end
  end
end
