defmodule Learn.Plug do
	import Plug.Conn

	def init(opts), do: opts

	def call(conn, _opts) do
		content = load_hits("count.txt")

		conn
		|> put_resp_content_type("text/plain")
		|> send_resp(200, content)
	end

	@doc """
	load_hits/1 reads the hits from a file and returns the value
	"""
	def load_hits(filepath) do
		case File.read(filepath) do
			{:ok, body}      ->
				body
			{:error, :enoent} ->
				File.write!(filepath, "1")
				load_hits(filepath)
		end
	end
end
