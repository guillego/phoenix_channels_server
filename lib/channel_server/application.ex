defmodule ChannelServer.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      ChannelServerWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: ChannelServer.PubSub},
      # Start Finch
      {Finch, name: ChannelServer.Finch},
      # Start the Endpoint (http/https)
      ChannelServerWeb.Endpoint
      # Start a worker by calling: ChannelServer.Worker.start_link(arg)
      # {ChannelServer.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ChannelServer.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ChannelServerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
