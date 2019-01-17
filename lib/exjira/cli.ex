defmodule ExJira.CLI do

  require Logger
  @moduledoc """
  Command line interface to generate tokens
  """

  def process do

#    ExJira.Config.set([site: site, private_key_file: private_key_file, consumer_key: consumer_key])
    with :ok <- ExJira.OAuth.get_request_token
      do
      confirm_credentials
      ExJira.OAuth.get_access_token
      ExJira.Config.get_tuples |> print_credentials
      else
        error -> error
    end
  end

  defp print_credentials(credentials) do

    IO.ANSI.green() <> "Paste the following content in your proyect config.exs file ->>" <> IO.ANSI.reset |> IO.puts
    IO.puts """
    config :ex_jira, oauth: [
    site: "#{credentials[:site]}",
    private_key_file: "#{credentials[:private_key_file]}",
    consumer_key: "#{credentials[:consumer_key]}",
    access_token: "#{credentials[:oauth_token]}",
    acess_token_secret: "#{credentials[:oauth_token_secret]}"
    ]
    """

  end
  defp confirm_credentials do

    IO.ANSI.green() <> "Open your browser at  to grant app authorization" |> IO.puts
    IO.puts(ExJira.OAuth.get_authorize_url)
    IO.puts("\n Press intro when ready")
    IO.gets("\n> ")

  end

end
