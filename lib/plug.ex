defmodule Learn.Plug do
	import Plug.Conn
	alias Learn.Tracker

	@filepath "count.txt"

	def init(options) do
		Tracker.start_link(String.to_integer(load_hits(@filepath)))
		options
	end

	def call(conn, _opts) do
		Tracker.increment()
		Tracker.store(@filepath)
		content = "#{Tracker.curr_count()}"

		conn
		|> put_resp_content_type("text/plain")
		|> send_resp(200, content)
	end

	@doc """
	load_hits/1 reads the hits from a file and returns the value
	"""
	def load_hits(filepath) do
		case File.read(filepath) do
			{:ok, content}      	->
				content
			{:error, :enoent} ->
				File.write!(filepath, "0")
				load_hits(filepath)
		end
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
