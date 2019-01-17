defmodule ExJira.API.Search do

  @moduledoc """
  Exposes the Search API interface.
  """

  @doc """
  Returns Jira issues related to JQL condition

  ## Examples

  iex> ExJira.API.search.using_jql("assignee = edwinallenz")
  "%{}"
  """

  import ExJira.API.Base

  def using_jql(jql) do
    request(:get, "rest/api/2/search", [ jql: jql ])
  end

end
