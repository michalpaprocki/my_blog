defmodule MyBlog.Utils.Utils do
  @moduledoc """
    Module holding the utility functions needed by the application.
  """
  alias MyBlog.Utils.MarkdownValidator

  @doc """
  Reads markdown files from `content/md/articles/` directory, validates them and returns their paths with titles.
  """
  def get_md_paths_and_titles(:articles) do
    Path.wildcard("content/md/articles/**/*.md")
    |> Enum.map(fn x -> MarkdownValidator.validate_md_file(x) end)
    |> Enum.map(fn y-> {elem(y, 0), extract_title(elem(y, 1))} end)
  end

  @doc """
  Reads contents of a markdown file.
  """
  def read_md(path) when is_binary(path) do
    file = File.read(path)
    case file do
      {:error, _msg} ->
        {:error, "Could not read file"}
      {:ok, data}->
        data
    end
  end

  @doc """
  This function takes path to and markdown file itself. Then runs a regex expression against the file that extracts the metadata from between the hyphens("---") and filters out all non-word characters. It prepares and converts metadata key-value pairs into a map.
  """
  def extract_metadata(md) do
    indices = Regex.run(~r/(?<=---)[\s\S]*?(?=---)/, md, return: :index)
    unfiltered_metadata =
      String.split(
        String.slice(md, (elem(hd(indices), 0))..(elem(hd(indices), 1) + 1)),
        ~r/[\n]/
      )
    filtered_meta = Enum.filter(unfiltered_metadata, fn x -> String.match?(x, ~r/\w+/) end)
    key_value_pairs = Enum.map(filtered_meta, fn f -> String.split(f, ~r/:/) end)
    map = Enum.into(key_value_pairs, %{}, fn [a, b] -> {String.trim(a), String.trim(b)} end)
    if !Map.has_key?(map, "tags") do
      raise "Articles metadata lacks tags property"
    end
    Map.replace(map, "tags", Enum.map(String.split(map["tags"], ","), fn x -> String.trim(x) end))
  end

  @doc """
  Runs a regex against a markdown file and returns everything after the first "#"(h1) tag.
  """
  def extract_article(md) do
    article = Regex.run(~r/(?=#).[\s\S]*/, md)
    case article do
      nil ->
        {:error, "Article has no content"}
      _ ->
        article
    end
  end

  @doc """
  Extracts an id from an article.
  """
  def extract_id(md) do
    hd(Regex.run(~r/(?<=id: ).*/, md))
  end

  @doc """
  Extracts a published entry from an article.
  """
  def extract_published(md) do
    hd(Regex.run(~r/(?<=published: ).*/, md))
  end

  @doc """
  Extracts a title form an article.
  """
  def extract_title(md) do
    hd(Regex.run(~r/(?<=title: ).*/, md))
  end

  @doc """
  Takes a list of maps and converts the strings under the 'published' key into a datetime.
  """
  def convert_map_string_to_date(map) when is_list(map) do
    map
    |> Enum.map(fn x -> Map.replace(x, "published", Date.from_iso8601!(x["published"])) end)
  end
end
