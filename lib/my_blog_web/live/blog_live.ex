defmodule MyBlogWeb.BlogLive do
  use MyBlogWeb, :live_view
  alias MyBlog.Blog

  def mount(_params, _session, socket) do
    metadata = Blog.get_articles_metadata()
    {:ok, socket|> assign(:metadata, metadata), layout: {MyBlogWeb.Layouts, :blog}}
  end

  def handle_params(_unsigned_params, uri, socket) do
    MyBlogWeb.Breadcrumbs.update_component("breadcrumbs_navigation", uri)
    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
      <div class="flex gap-2 flex-col p-8">
        <%= for meta <- @metadata do %>
          <.link navigate={"/blog/#{meta["title"]}"} class="flex text-sm flex-col p-2 hover:-translate-y-1 transition rounded-md gap-2 bg-bg-ui/70 hover:bg-accent text-text-ui">
            <span class="font-bold text-base"><%= meta["title"] %></span>
            <span class="font-semibold"><%= meta["author"] %></span>
            <span><%= meta["published"] %></span>
          </.link>
        <% end %>
      </div>
    """
  end
end
