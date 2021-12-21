require "erb"
require_dir "./view"

module View
	extend self

	@@layout = ERB.new(File.read("view/layout.html.ebr"))
	def layout( ctrl, title = "", code = 200, type = "text/html", &block )
		response = ctrl.response
		response.status = code
		response["Content-Type"] = type
		response.body = @@layout.result(binding)
		return true
	end
end

