defmodule Dictionary.Runtime.Application do
  @moduledoc false
  use Application

  def start(_type, _args) do
    children = [
      { Dictionary.Runtime.Server, [] }
    ]

    options = [
      name: Dictionary.Runtime.Server,
      strategy: :one_for_one
    ]

    Supervisor.start_link(children, options)
  end
end
