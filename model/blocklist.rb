require "json"
require "./model/user"

module Blocklist
	extend self

	class BlockItem
		FIELDS = [ :id ]
		include JSONClass
	end

	@@data = JSON.parse(File.read("db/block_list.json")).map {|i| BlockItem.from_json(i) }
	@@deadline = nil

	def items()
		@@data
	end
	def to_wait_ms()
		return 0 if !@@deadline

		s = ( (@@deadline - Time.now ) * 1000).to_i
		return 0 if s < 0
		return s
	end

	def update()
		@@data.each {|item|
			if (user = User.from_id?(item.id)) && !user.has_avatar?()
				user.download_avatar()
				random_sleep
			else
				user = User.from_json( JSON.parse( %x( set -x; curl "https://gab.com/api/v1/accounts/#{item.id}" ) ) )
				user.save

				random_sleep
			end
		}
	end

	def random_sleep()
		delay = rand(40)+20
		@@deadline = Time.now + delay
		sleep(delay)
	end
end

Thread.new { Blocklist.update }

