defmodule MyBlogWeb.ArticleLive do
  use MyBlogWeb, :live_view
  alias MyBlog.Blog

  def mount(params, _session, socket) do
    %{"title" => title} = params
    article = Blog.get_article_by_title(title)
  {:ok, socket|> assign(:article, article)}
  end

  def render(assigns) do
    ~H"""
      <article id="article" phx-hook="HandleCopy" class="prose prose-h1:text-sky-700">
        <%= Phoenix.HTML.raw(Earmark.as_html!(@article)) %>
      </article>
    """
  end
end
