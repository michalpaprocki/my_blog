defmodule MyBlogWeb.Header.ThemeSwitcher do
  use MyBlogWeb, :live_component

  def update(assigns, socket) do
    options = ["blue", "blue-dark", "green", "green-dark"]
    {:ok, socket |> assign(:id, assigns.id) |> assign(:options, options) |> assign(:show, false)}
  end
  def render(assigns) do
    ~H"""
      <div class={"flex items-center justify-end gap-2 rounded-lg #{if @show, do: "bg-accent w-60", else: "bg-bg w-0"} transition-all"}>
        <.button
          class={"order-2 group hover:ring-2 ring-accent #{if @show , do: "ring-2"} transition"}
          aria-label="toggles the theme selector"
          type="button"
          phx-target={@myself}
          phx-click={if !@show, do: "open_theme"}
        >
        🎨
        </.button>
        <%= if @show do %>
          <div
            class="order-1 top-12 right-0 p-1 rounded-md"
            phx-click-away="close_theme"
            phx-target={@myself}
          >
            <label class="invisible" for={"theme_switcher_select"} aria-label="theme selector label"></label>
            <select
              aria-label="theme selector"
              id={"theme_switcher_select"}
              class="group-hover:bg-accent text-text rounded-md text-sm p-1 w-[20ch] bg-bg transition"
              phx-hook="HandleTheme"
            >
              <%= for o <- @options do %>
                <option value={o}>
                  <%= o %>
                </option>
              <% end %>
            </select>
          </div>
        <% end %>
      </div>
    """
  end
  def handle_event("open_theme", _unsigned_params, socket) do
    {:noreply, socket |> assign(:show, true)}
  end

  def handle_event("close_theme",_params, socket) do
    {:noreply, socket |> assign(:show, false)}
  end
end
