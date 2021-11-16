defmodule Learn.Plug do
	import Plug.Conn

	def init(opts), do: opts

	def call(conn, _opts) do
		content =
			"count.txt"
			|> load_hits()
			|> increment_hits("count.txt")

		conn
		|> put_resp_content_type("text/plain")
		|> send_resp(200, content)
	end

	@doc """
	load_hits/1 reads the hits from a file and returns the value
	"""
	def load_hits(filepath) do
		case File.read(filepath) do
			{:ok, body}      	->
				body
			{:error, :enoent} ->
				File.write!(filepath, "1")
				load_hits(filepath)
		end
	end

	@doc """
	increment_hits/1 increments the hits in a file
	"""
	def increment_hits(body, filepath) do
		content = "#{String.to_integer(body) + 1}"
		File.write!(filepath, content)
		content
	end

	#========= Basic Flow =========#
	# User hits the server
	# Server loads the hits from a file
	# Server increments the hits
	# Server returns the hits
	# Server saves the hits to a file

	#========= Advanced Flow =========#
	# User hits the server
	# Server loads the hits from a file and stores it in cache
	# Server increments the hits in cache
	# Server returns the hits from cache
	# Server saves the hits to a file every every 10 hits OR every 30 seconds (if the hits are less than 10)
end
