defmodule IssuesTest do
  use ExUnit.Case, async: false

  setup_all do
    ExJira.Test.standard_credentials |> ExJira.Config.set

    :ok
  end

  test "find returns info for an issue using an issue key" do
    issue = ExJira.API.Issues.find("YE-23")

    assert issue.key == "YE-23"
    assert issue.id != ""
    assert issue.fields.summary != ""
  end

  test "find returns info for an issue using an issue id" do
    issue = ExJira.API.Issues.find("21402")

    assert issue.key != ""
    assert issue.id == "21402"
    assert issue.fields.summary != ""
  end

  test "in open sprints returns issues in open sprints" do
    results = ExJira.API.Issues.in_open_sprints

    issue_count = results.issues |> Enum.count

    assert issue_count > 0
  end

end
