defmodule MyBlogWeb.Breadcrumbs do
  use MyBlogWeb, :live_component

  def update_component(cid, assigns) do
    send_update(__MODULE__, id: cid, update: assigns)
  end
  def update(%{:update =>  uri}, socket) do
    sliced =
      uri
      |> String.split("/")
      |> Enum.drop(3)
      |> Enum.filter(fn x -> x != "" end)
      |> Enum.map(fn x -> URI.decode(x) end)
    uris = prep_uri(sliced, [])
    {:ok, socket |> assign(:uri, Enum.zip(sliced, uris))}
  end
  def update(_assigns, socket) do
    {:ok, socket |> assign(:uri, "")}
  end

  defp prep_uri(uris, acc) when is_list(uris) do
    if length(uris) == 0 do
      Enum.map(acc, fn a -> "/" <> a end)
    else
      uri_prepped = Enum.join(uris, "/")

      new_uris =
        uris |> Enum.reverse() |> tl |> Enum.reverse()

      prep_uri(new_uris, [uri_prepped | acc])
    end
  end

  def render(%{:uri => ""} = assigns) do
    ~H"""
    <div class="hidden sm:flex items-center animate-pulse ring-2 ring-accent p-1 px-6 mx-9 mt-10 rounded-md min-h-10">
      <nav aria="navigation" aria-label="breadcrumbs navigation" class="rounded-md font-semibold font-mono flex items-center">
      <span class="p-1 inline-block">
          <.link
            class="break-keep inline-block text-center text-sm p-1 rounded-md hover:bg-accent hover:text-text-ui"
            navigate={"/"}>
            home
          </.link>
        </span>
      </nav>
    </div>
    """
  end
  def render(%{:uri => _uri} = assigns) do
    ~H"""
    <div class="hidden sm:flex items-center ring-2 ring-accent p-1 px-6 mx-9 mt-10 rounded-md min-h-10">
      <nav aria="navigation" aria-label="breadcrumbs navigation" class="rounded-md font-semibold font-mono flex items-center overflow-hidden truncate">
      <span class="p-1 inline-block">
        <.link
            class="break-keep inline-block text-center text-sm p-1 rounded-md hover:bg-accent hover:text-text-ui"
            navigate={"/"}>
            home
        </.link>
        </span>
        <%= for u <- @uri do %>
          <%= if Enum.at(@uri, length(@uri)-1) == u do %>
            <span class="p-1 inline-block">
              <span aria-hidden="true">></span>
              <span aria-label="this page" class="break-keep inline-block text-center text-sm p-1 text-accent rounded-md">
                <%= elem(u, 0) %>
              </span>
            </span>
          <% else %>
            <span class="p-1 inline-block">
              <span aria-hidden="true">></span>
              <.link
                class="break-keep inline-block text-center text-sm p-1 rounded-md hover:bg-accent hover:text-text-ui"
                navigate={elem(u, 1)}
              >
                <%= elem(u, 0) %>
              </.link>
            </span>
          <% end %>
        <% end %>
      </nav>
    </div>
    """
  end
end
