defmodule Learn.Supervisor do
	use Application

	def start(_type, _args) do
		children = [
			{Plug.Cowboy, scheme: :http, plug: Learn.Plug, options: [port: 4001]}
		]
		Supervisor.start_link(children, strategy: :one_for_one)
	end
end
