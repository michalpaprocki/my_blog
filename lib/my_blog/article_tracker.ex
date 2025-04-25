defmodule MyBlog.ArticleTracker do
  use GenServer
  alias MyBlog.Utils.Utils

  @moduledoc """
  A GenServer module responsible for keeping track of article titles and file paths.
  """

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: ArticleTracker)
  end

  def init(_) do
    :ets.new(:articles_data, [:protected, :set, :named_table])
    articles = Utils.get_md_paths_and_titles(:articles)
    Enum.map(articles, fn a -> :ets.insert(:articles_data, a) end)
    IO.puts("\nStarting ArticleTracker\n")
    {:ok, %{:article => :articles_data}}
  end
    # # # # callers # # # #

    def save_article(title, path) do
      GenServer.call(ArticleTracker, {:save_article, {path, title}})
    end

    def get_article_path(title) do
      GenServer.call(ArticleTracker, {:read_article, {title}})
    end

    def get_all_article_paths() do
      GenServer.call(ArticleTracker, {:all_article_paths})
    end

    # # # # handlers # # # #

    def handle_call({:save_article, {path, title}}, _from, state) do
      result = :ets.insert(state.article, {path, title})
      {:reply, result, state}
    end

    def handle_call({:read_article, {title}}, _from, state) do
      result = :ets.match(state.article, {:"$1", title})
      case result do
        [] ->
          {:reply, :not_found, state}
        _ ->
          {:reply, hd(hd(result)), state}
      end
    end

    def handle_call({:all_article_paths}, _from, state) do
      result = :ets.match(state.article, {:"$1", :_})
      case result do
        [] ->
          {:reply, :empty, state}
        _ ->
          {:reply, List.flatten(result), state}
      end
    end
end
