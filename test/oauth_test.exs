defmodule ExJira.OAuthTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock

  setup_all do

    ExJira.Test.oauth_credentials |> ExJira.Config.set
    ExVCR.Config.cassette_library_dir("fixture/vcr_cassettes")
    :ok
  end

  @tag must: true
  test "token request returns :ok"  do
    assert ExJira.OAuth.get_request_token == :ok
    assert ExJira.Config.get_tuples |> is_list == true
  end

  test "token request adds keys to config store" do
    ExJira.OAuth.get_request_token

#    assert Regex.match?(~r/\w+/, ExJira.Config.get[:oauth_token])
    assert ExJira.Config.get[:oauth_token] != ''
    assert ExJira.Config.get[:oauth_token_secret] != ''
    assert ExJira.Config.get_tuples == %{}
  end

  test "access token request returns :ok" do
    ExJira.OAuth.get_request_token
    assert ExJira.OAuth.get_access_token == :ok
  end

  test "access token request adds keys to config store" do
    ExJira.OAuth.get_request_token
    ExJira.OAuth.get_access_token

    assert ExJira.Config.get[:access_token] != ''
    assert ExJira.Config.get[:access_token_secret] != '' 
  end

end
