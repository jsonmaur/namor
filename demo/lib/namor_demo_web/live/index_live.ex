defmodule NamorDemoWeb.IndexLive do
  use NamorDemoWeb, :live_view
  use Namor

  alias NamorDemo.Params

  def handle_params(params, uri, socket) do
    changeset =
      Params.changeset(%Params{}, %{
        words: Map.get(params, "words", "2") |> String.to_integer(),
        separator: Map.get(params, "separator", "-"),
        salt: Map.get(params, "salt", "0") |> String.to_integer(),
        salt_type: Map.get(params, "salt_type", "mixed") |> String.to_existing_atom(),
        dictionary: Map.get(params, "dictionary", "default") |> String.to_existing_atom()
      })

    socket =
      socket
      |> assign(:uri, URI.parse(uri))
      |> assign(:changeset, changeset)

    socket =
      case Ecto.Changeset.apply_action(changeset, :validate) do
        {:ok, data} ->
          socket =
            socket
            |> assign(:name, connected?(socket) && generate_name(data))

        {:error, changeset} ->
          socket =
            socket
            |> assign(:name, nil)
            |> assign(:changeset, changeset)
      end

    {:noreply, socket}
  end

  def handle_event("generate", %{"_target" => ["params", target], "params" => params}, socket) do
    query = %{target => Map.get(params, target)}
    {:noreply, push_patch(socket, to: get_path(socket, query))}
  end

  def handle_event("regenerate", _values, socket) do
    {:noreply, push_patch(socket, to: get_path(socket))}
  end

  defp get_path(socket, query \\ %{}) do
    query =
      URI.decode_query(socket.assigns.uri.query || "")
      |> Map.merge(query)

    Routes.live_path(socket, __MODULE__, query)
  end

  defp generate_name(%Params{} = params) do
    {:ok, name} =
      Namor.generate(
        words: params.words,
        salt: params.salt,
        salt_type: params.salt_type,
        separator: params.separator,
        dictionary: params.dictionary
      )

    name
  end
end
