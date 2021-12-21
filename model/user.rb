class User
	class Field
		FIELDS = [ :name, :value ]
		include JSONClass
	end

	FS_DB_PATH = "db/user"
	FIELDS = [
		:id, :username, :acct, :display_name, :locked, :bot, :created_at,
		:note, :url, :avatar, :avatar_static, :headerm, :header_static,
		:is_spam, :followers_count, :statuses_count, :is_pro, :is_verified,
		:is_donor, :is_invester, :fields
	]
	include JSONClass
	def post_json_load()
		@fields.map! {|data| Field.from_json(data) }
	end

	MISSING_AVATAR_URL = "https://gab.com/avatars/original/missing.png"
	FS_DEFAULT_AVATAR = "db/cache/user-avatar-0.jpg"

	if !File.exist?(FS_DEFAULT_AVATAR)
		%x( set -x; curl "#{MISSING_AVATAR_URL}" -o "#{FS_DEFAULT_AVATAR}" )
	end

	def fs_avatar_path()
		"db/cache/user-avatar-#{id}.jpg"
	end
	def has_avatar?()
		File.exist?( fs_avatar_path )
	end
	def download_avatar()
		%x( set -x; curl "#{avatar_static}" -o #{fs_avatar_path} )
	end
end

