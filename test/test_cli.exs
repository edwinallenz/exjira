defmodule ExJira.CliTest do
  use ExUnit.Case
  import ExJira.CLI, only: [ parse_args: 1 ]

  test "help parameters" do
    assert parse_args(["-h", "anything"]) == :help
    assert parse_args(["--help", "anything"]) == :help
  end

  test "three values returned if three given" do
    assert parse_args(["https://myaccount.atlassian.net", "jira_privatekey.pem", "ElixirJiraClientConsumerKey"]) == { "https://myaccount.atlassian.net", "jira_privatekey.pem", "ElixirJiraClientConsumerKey" }
  end
end
