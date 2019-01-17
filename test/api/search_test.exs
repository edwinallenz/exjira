defmodule SearchTest do
  use ExUnit.Case, async: false

  setup_all do
    ExJira.Test.standard_credentials |> ExJira.Config.set

    :ok
  end

  test "using jql accepts standard jql searches" do
    results = ExJira.API.Search.using_jql("assignee = carlos")
    test_result = results.issues |> List.first

    assert test_result.fields.status.name == "To Do"
  end

end
