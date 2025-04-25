defmodule MyBlogWeb.Header.Header do
  use MyBlogWeb, :live_component

  def update(assigns, socket) do
    {:ok, socket |> assign(assigns)}
  end

 def render(assigns) do
    ~H"""
    <header class="h-header relative">
      <div class="h-header fixed w-full bg-bg-ui/90 text-text-ui z-10 px-8 flex gap-2 items-center">
        <nav class="flex justify-start items-center w-full gap-2">
          <div>
            <.link navigate={"/"} class="px-6 rounded-sm py-2 hover:bg-accent text-2xl font-bold transition">My Blog</.link>
          </div>
          <div>
            <.link navigate={"/blog"} class="px-6 rounded-sm py-2 hover:bg-accent text-xl font-semibold transition">Blog</.link>
          </div>
        </nav>
        <.live_component module={MyBlogWeb.Header.ThemeSwitcher} id="theme_switcher" />
      </div>
    </header>
    """
  end
end
