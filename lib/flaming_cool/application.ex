defmodule FlamingCool.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    flame_parent = FLAME.Parent.get()
    # {FLAME.Pool, min: 0, max: 10, max_concurrency: 5, idle_shutdown_after: 30_000, log: :debug}
    IO.puts("We ARE STARTING!!!")

    children =
      [
        FlamingCoolWeb.Telemetry,
        {Ecto.Migrator,
         repos: Application.fetch_env!(:flaming_cool, :ecto_repos), skip: skip_migrations?()},
        {DNSCluster, query: Application.get_env(:flaming_cool, :dns_cluster_query) || :ignore},
        {Phoenix.PubSub, name: FlamingCool.PubSub},
        {FLAME.Pool,
         name: FlamingCool.Flamethrower,
         min: 1,
         max: 10,
         max_concurrency: 5,
         idle_shutdown_after: 30_000,
         log: :debug},
        !flame_parent && FlamingCoolWeb.Endpoint,
        {Finch, name: FlamingCool.Finch}

        # {FLAME.Pool, min: 0, max: 10, max_concurrency: 5, idle_shutdown_after: 30_000, log: :debug}
        # Start a worker by calling: FlamingCool.Worker.start_link(arg)
        # {FlamingCool.Worker, arg},
        # Start to serve requests, typically the last entry
      ]
      |> Enum.filter(& &1)

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: FlamingCool.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    FlamingCoolWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp skip_migrations?() do
    # By default, sqlite migrations are run when using a release
    System.get_env("RELEASE_NAME") != nil
  end
end
