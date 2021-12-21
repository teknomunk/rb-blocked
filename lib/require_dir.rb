def require_dir( dir )
	Dir.each_child(dir) {|c|
		require File.join(dir,c) if /\.rb$/ =~ c
	}
end

