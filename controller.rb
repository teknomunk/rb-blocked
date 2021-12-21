#require_dir "./controller"

class Controller
	def route()
		switch(%r{/user/([0-9]+)}) {|m|
			return error("User #{m[1]} not found") unless user = User.from_id?(m[1])

			term("/avatar.jpg") { return user_avatar( user ) }
		}
		term("/") { return landing() }
		term("/style.css") { return style() }

		return false
	end

	def user_avatar( user )
		filename = user.has_avatar?() ? user.fs_avatar_path : User::FS_DEFAULT_AVATAR
		return send_file( filename, "image/jpeg" )
	end

	@@landing = ERB.new(File.read("view/landing.html.erb"))
	def landing()
		return View.layout(self,"Landing") {
			@@landing.result(binding)
		}
	end
	def style()
		return send_file( "view/style.css", "text/css" )
	end

	# Handle routing
	attr_reader :response
	attr_reader :root
	def initialize( req, res )
		@request = req; @response = res
		@_path = req.path
		@root = "../" * (@_path.count("/")-1)
	end
	def switch( s, &block )
		case s
			when String
				if( @_path[0,s.size] == s )
					@_path = @_path[s.size]
					yield
				end
			when Regexp
				s = Regexp.new("^" + s.source)
				if md = s.match(@_path)
					@_path = md.post_match
					yield(md)
				end
		end
	end
	def term( s, &block )
		case s
			when String
				if @_path == s
					yield
					@_path = nil
				end
			when Regex
				s = Regexp.new("^" + s.source + "$")
				if md = s.match(@_path)
					yield(md)
					@_path = nil
				end
		end
	end
	def send_file( filename, type )
		return false unless File.exist?(filename)

		@response["Content-Type"] = type
		@response["Content-Size"] = File.size(filename)
		@response.body = File.open(filename)

		return true
	end

	def path_to_avatar(user)
		"#{root}user/#{user.id}/avatar.jpg"
	end
	def path_to_gab(user)
		"https://gab.com/#{user.username}"
	end
end

