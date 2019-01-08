defmodule ExJira do
  use Application
  require Logger
  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    Logger.info "Startint ExJira Plugin"

    children = [
      # Define workers and child supervisors to be supervised
      # worker(Exjira.Worker, [arg1, arg2, arg3])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Exjira.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
