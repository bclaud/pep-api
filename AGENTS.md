Project Overview

Phoenix web app using LiveView for interactive UIs, Ecto with PostgreSQL for data persistence, and Oban for background jobs. Follow Elixir/Phoenix conventions: use GenServers for state, PubSub for real-time updates, and Oban workers for async tasks.
Model Configuration

Setup Commands

    Install dependencies: mix deps.get

    Create/updates database: mix ecto.create && mix ecto.migrate

    Start server with jobs: mix phx.server

    Interactive dev: iex -S mix phx.server

    Install Oban (if new): Add {:oban, "~> 2.20"} to mix.exs, then mix deps.get and run migration.

Testing Instructions

    Run full suite: mix test

    Specific file: mix test test/my_file_test.exs

    Phoenix tests: mix test test/my_live_test.exs --trace

    Credo linting: mix credo --strict

    Dialyzer types: mix dialyzer

    Always run tests after changes; fix failures before committing. Add tests for new features, especially LiveView components and Oban workers.​​

Oban Job Handling

    Define workers in lib/my_app/workers/: defmodule MyApp.Workers.MyJob do use Oban.Worker; def perform(%Oban.Job{...}) do ... end end

    Insert job: MyApp.Workers.MyJob.new(%{}) |> Oban.insert()

    Monitor: Use Oban Web dashboard or LiveView for job status via PubSub broadcasts.

    Queue config in config/config.exs: config :my_app, Oban, repo: MyApp.Repo, queues: [default: 10]

    For LiveView integration, broadcast job progress via Phoenix.PubSub.

Code Style

    Use single quotes for atoms/strings where idiomatic.

    Pipe |> operators for readability.

    LiveView: Prefer function components (~F), handle_params/3 for data loading, handle_event/3 for actions.

    Modules: lib/my_app_web/ for web (controllers, views, LiveViews), lib/my_app/ for app logic.

    Contexts: Use Phoenix contexts for business logic.

    Commit messages: Conventional (feat:, fix:, chore:).

Common Tasks

    Add LiveView: mix phx.gen.live Blog Post posts title body

    Oban migration: mix ecto.gen.migration create_oban_jobs then add Oban schema.

    Real-time jobs: Broadcast from Oban worker Phoenix.PubSub.broadcast(MyApp.PubSub, "jobs", {:updated, job_id}).

Security & Best Practices

    Use Ecto queries with where and preload to avoid N+1.

    Oban: Set max_attempts: 3, unique jobs with unique: [period: 60].

    Never commit secrets; use config/runtime.exs.

    Prod: Set config :phoenix, :plug, ... for security plugs.
