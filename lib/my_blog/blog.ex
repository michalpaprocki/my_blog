defmodule MyBlog.Blog do
  alias MyBlog.ArticleTracker
  alias MyBlog.Utils.Utils

  @doc """
  Takes an article's title and returns the content.
  """
  def get_article_by_title(title) do
    case ArticleTracker.get_article_path(title) do
      :not_found ->
        {:error, "No article titled `#{title}` found"}
      article_path ->
        hd(Utils.read_md(article_path) |> Utils.extract_article())
    end
  end

  @doc """
  Returns article's metadata.
  """
  def get_article_metadata(title) do
    path = ArticleTracker.get_article_path(title)
    file = Utils.read_md(path)
    Utils.extract_metadata(file)
  end

   @doc """
  Returns the metadata of all of the articles.
  """
  def get_articles_metadata() do
    case ArticleTracker.get_all_article_paths() do
      :empty ->
        :empty
      paths ->
        metadata =
        Enum.map(paths, fn p -> Utils.read_md(p) end)
        |> Enum.map(fn p -> Utils.extract_metadata(p) end)
        |> Utils.convert_map_string_to_date()
        |> Enum.sort(fn am1, am2 -> Date.compare(am1["published"], am2["published"]) != :lt end)
        metadata
    end
  end
end
