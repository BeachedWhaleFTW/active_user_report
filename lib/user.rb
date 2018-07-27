class User #should probably be a struct but maybe not
	attr_accessor :username, :irl_name, :last_login, :total_logins, :status

	def initialize(args)
		@username = args["username"] || ""
		@irl_name = args["name"] || ""
		@last_login = args["last_login"] || ""
		@total_logins = args["total_logins"] || ""
		@status = args["status"] || ""
	end
end