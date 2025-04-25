defmodule MyBlog.Utils.MarkdownValidator do
  alias MyBlog.Utils.Utils
  @moduledoc """
  This module is responsible for validating markdown files.
  """
  @md_keys [ "id", "title", "excerpt", "author", "keywords", "tags", "published", "bg"]

  @doc """
  Runs a series of checks to validate file's existence, extension, metadata and content. Raises if validation fails, returns `path` and file content when complete.
  """
  def validate_md_file(path) do
      path
      |> raise_file_non_existent
      |> raise_file_wrong_ext
      |> raise_file_no_meta
      |> raise_file_no_content
      |> raise_incorrect_date_format
  end

  defp raise_file_non_existent(path) do
    {status, data} = File.read(path)
      if status == :error do
        raise :file.format_error(data)
      else
        {path, data}
      end
  end

  defp raise_file_wrong_ext({path, data}) do
    if Path.extname(path) != ".md" do
      raise "File located at #{path} is not a markdown file."
    else
      {path, data}
    end
  end

  defp raise_file_no_meta({path, data}) do
    metadata = Utils.extract_metadata(data)
    missing = Enum.filter(@md_keys, fn k -> !Map.has_key?(metadata, k) end)
    if length(missing) > 0, do: raise "File's metadata is missing the following properties: #{Enum.map(Enum.with_index(missing), fn {x, index} -> if index == length(missing)-1, do: x<>".", else: x<>", " end)}"
    {path, data}
  end

  defp raise_file_no_content({path, data}) do
    content = Utils.extract_article(data)
    case content do
      {:error, _msg} ->
      raise "File located at #{path} must have content part that starts with a h1 heading(#)."
      _->
        {path, data}
      end
  end

  defp raise_incorrect_date_format({path, data}) do
    metadata =  Utils.extract_metadata(data)
    published = Map.fetch!(metadata, "published")
    case Date.from_iso8601(published) do
      {:ok, _} ->
        {path, data}
      _->
        raise "Incorrect value of field 'published' specified, use format: 2000-01-01"
    end
  end

end
