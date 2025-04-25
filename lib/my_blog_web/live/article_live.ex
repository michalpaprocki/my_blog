defmodule MyBlogWeb.ArticleLive do
  use MyBlogWeb, :live_view
  alias MyBlog.Blog

  def mount(params, _session, socket) do
    %{"title" => title} = params
    article = Blog.get_article_by_title(title)
  {:ok, socket|> assign(:article, article), layout: {MyBlogWeb.Layouts, :blog}}
  end

  def handle_params(_unsigned_params, uri, socket) do
    MyBlogWeb.Breadcrumbs.update_component("breadcrumbs_navigation", uri)
    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
      <article id="article" phx-hook="HandleCopy" class="prose prose-h1:text-accent prose-h2:text-accent/80 prose-h3:text-accent/70 text-text">
        <%= Phoenix.HTML.raw(Earmark.as_html!(@article)) %>
      </article>
    """
  end
end
