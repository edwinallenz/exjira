defmodule ExJira.API.Base do

  @doc """
  Sends an api request to the configured JIRA instance.
  """
  def request(method, path, params \\ []) do
    config = ExJira.Config.get_tuples
    IO.inspect(config)
    consumer = { config[:consumer_key], config[:private_key_file], :rsa_sha1 }
    IO.inspect(consumer)
    ExJira.OAuth.request(method, request_url(config[:site], path), params, consumer, config[:access_token], config[:access_token_secret])
      |> parse_result
  end

    defp request_url(site, path) do
      "#{site}/#{path}" |> to_charlist
    end

    defp parse_result(result) do
      {:ok, {_response, _header, body}} = result
      IO.inspect(result)
      ExJira.Json.decode!(body)
    end

end
