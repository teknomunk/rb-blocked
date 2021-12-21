module JSONClass
	def self.included(om)
		om.extend ClassMethods
		om.attr_accessor *om::FIELDS
		om.attr_accessor :extra
	end

	module ClassMethods
		def from_json( obj )
			extra = Hash[ obj.map {|k,v| [k.intern,v] } ]
			args = self::FIELDS.map {|f| extra[f] }
			self::FIELDS.each {|f| extra.delete(f) }

			res = self.new( args, extra )
			if res.respond_to?(:post_json_load)
				res.post_json_load
			end
			return res
		end
		def from_file( filename )
			self.from_json( JSON.parse( File.read(filename) ) )
		end
		def from_id?( id )
			if File.exist?(filename=File.join(self::FS_DB_PATH,id.to_s+".json"))
				from_file( filename )
			else
				nil
			end
		end
		def from_id(id)
			res = from_id?
			raise "#{self.class} (id=#{id}) not found" if !res
			return res
		end
	end

	def initialize( args, extra = {} )
		self.class::FIELDS.each_with_index {|f,i| instance_variable_set( "@#{f}", args[i] ) }
		@extra = extra
	end

	def filename()
		File.join(self.class::FS_DB_PATH,id.to_s+".json")
	end

	def save()
		tmp = filename + ".tmp"
		begin
			File.open(tmp,"w") {|f| f << self.to_json( indent: "\t" ) }
			File.rename(tmp,filename)
		ensure
			File.delete(tmp) if File.exist?(tmp)
		end
	end

	def to_json_object()
		h = @extra.clone
		self.class::FIELDS.each {|f|
			var = instance_variable_get("@#{f}")
			if var.respond_to? :to_json_object
				h[f] = var.to_json_object
			else
				h[f] = var
			end
		}
		return h
	end
	def to_json(*args)
		to_json_object().to_json(*args)
	end
	def []( sym )
		if self.class::FIELDS.include?(sym)
			instance_variable_get("@#{sym}")
		else
			@extra[sym]
		end
	end
	def []=( sym, value )
		if self.class::FIELDS.include?(sym)
			instance_variable_set("@#{sym}",value)
		else
			@extra[sym] = value
		end
	end
end

class Array
	def to_json_object()
		self.map {|i|
			if i.respond_to?(:to_json_object)
				i.to_json_object
			else
				i
			end
		}
	end
end
class Hash
	def to_json_object()
		self.map {|k,v|
			if v.respond_to?(:to_json_object)
				[k,v.to_json_object]
			else
				[k,v]
			end
		}
	end
end

