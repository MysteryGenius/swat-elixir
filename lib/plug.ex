defmodule Learn.Plug do
	import Plug.Conn
	alias Learn.Tracker

	@filepath "count.txt"

	def init(options) do
		count = String.to_integer(load_hits(@filepath))
		:ets.new(:session, [:named_table, :public, read_concurrency: true])
		Tracker.start_link(count)
		options
	end

	def call(conn, _opts) do
		Tracker.increment()
		content = "#{Tracker.curr_count()}"

		conn
		|> store_hits(@filepath)
		|> put_resp_content_type("text/plain")
		|> send_resp(200, content)
	end

	#========= Abstraction Barrier =========#

	defp load_hits(filepath) do
		case File.read(filepath) do
			{:ok, content}      	->
				content
				{:error, :enoent} ->
					File.write!(filepath, "0")
					load_hits(filepath)
				end
			end

	defp store_hits(conn, filepath) do
		opts = Plug.Session.init(store: :ets, key: "_learn_session", secure: true, table: :session)
    conn = Plug.Session.call(conn, opts)
    conn = fetch_session(conn)
		last_stored = if get_session(conn, :last_stored) == nil, do: 0, else: String.to_integer(get_session(conn, :last_stored))
		IO.inspect last_stored
		if last_stored == 0 || ((Tracker.curr_count() - last_stored) >= 10) do
			Tracker.store(filepath)
			put_session(conn, :last_stored, "#{Tracker.curr_count()}")
		else
			conn
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
