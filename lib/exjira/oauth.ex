defmodule ExJira.OAuth do

  require Logger

  @moduledoc """
  A set of wrappers over the :oauth methods.
  """

  @doc """
  Sends a GET request.
  """
  def request(:get, url, params, consumer_tuple, access_token, access_token_secret) do
    :oauth.get(url, params, consumer_tuple, access_token, access_token_secret)
  end

  @doc """
  Sends a POST request.
  """
  def request(:post, url, params, consumer_tuple, access_token, access_token_secret) do
    :oauth.post(url, params, consumer_tuple, access_token, access_token_secret)
  end

  @doc """
  Requests a new set of request tokens.
  """
  def get_request_token do
    config = ExJira.Config.get_tuples
    consumer = { config[:consumer_key], config[:private_key_file], :rsa_sha1 }
    token_request_url = "#{config[:site]}/plugins/servlet/oauth/request-token"
    {:ok, request_token_response} = :oauth.post(to_charlist(token_request_url), [], consumer)

    case validate_respose(request_token_response) do
      :ok ->
        :oauth.params_decode(request_token_response)
        |> get_keyword_list()
        |> Keyword.merge(config)
        |> ExJira.Config.set
        IO.inspect(ExJira.Config.get_tuples)
        :ok
      error -> error
    end
  end

  defp validate_respose({request_token_response = {_protlocol, status_code, _}, _header, body}) do
    Logger.info("Response code from request_token #{status_code}")
    if status_code == 200 do
      :ok
    else
      problem = to_string(body) |> String.split("&") |> List.first
      Logger.error("Unable to  token, #{problem}")
      {:error, "Unable to get token, #{problem}"}
    end
  end
  @doc """
  Returns the redirect url for authorizing the use of the request tokens.
  """
  def get_authorize_url do
    config = ExJira.Config.get_tuples
    :oauth.uri(to_charlist("#{config[:site]}/plugins/servlet/oauth/authorize"), [{'oauth_token', config[:oauth_token]}])
  end

  @doc """
  Requests a new access token/access token secret pair.
  """
  def get_access_token do
    config = ExJira.Config.get_tuples
    consumer = { config[:consumer_key], config[:private_key_file], :rsa_sha1 }
    access_token_request_url = "#{config[:site]}/plugins/servlet/oauth/access-token"

    #    {:ok, access_token_response} = :oauth.post(to_charlist(access_token_request_url), [{"oauth_session_handle",config[:oauth_session_handle]}], consumer, config[:oauth_token], config[:oauth_token_secret])
    {:ok, access_token_response} = :oauth.post(to_charlist(access_token_request_url), [], consumer, config[:oauth_token], config[:oauth_token_secret])

    IO.inspect(access_token_response)
    updated_config = :oauth.params_decode(access_token_response)
                      |> get_keyword_list()
                      |> Keyword.merge(config)
    IO.inspect(updated_config)
    Logger.error("------------------------")
    ExJira.Config.set(updated_config)
    :ok
  end

  defp get_keyword_list([]) do
    []
  end

  defp get_keyword_list(tokens) do
    tokens |> Enum.map(fn({k, v}) -> {k |> List.to_atom, to_charlist(v)} end)
  end

end
