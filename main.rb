$LOAD_PATH.unshift("./lib/")

require "erb"
require "net/http"
require "require_dir"
require "webrick"
require_dir "./lib"
require_dir "./model"
require "./controller"
require "./view"

if __FILE__ == $0
	server = WEBrick::HTTPServer.new( :Port => 8081 )
	server.mount_proc("/") {|req,res|
		Controller.new( req, res ).route()
		true
	}

	trap("INT") { server.shutdown }

	server.start
end

