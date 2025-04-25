defmodule MyBlogWeb.HomeLive do
  use MyBlogWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="flex justify-center">
      <h1 class="text-xl font-semibold ring-2 ring-accent p-2 rounded-md">My Blog</h1>
    </div>
    """
  end
end
