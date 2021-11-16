defmodule Learn.Supervisor do
	use Application
	require Logger

	def start(_type, _args) do
		children = [
			{Plug.Cowboy, scheme: :http, plug: Learn.Plug, options: [port: 4001]}
		]
		Logger.info("Starting application...")
		Supervisor.start_link(children, strategy: :one_for_one)
	end
end
