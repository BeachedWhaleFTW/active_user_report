require "csv"
require_relative "user"

class Report
	attr_accessor :active_users, :login_array, :user_list

	def initialize(args)
		@active_users = import(args["filename1"])
		@login_array = import(args["filename2"])
		@user_list = Array.new
	end

	def import(file)
		array = Array.new
		CSV.foreach(file, :headers => true) do |row|
			array << row
		end
		return array
	end

	def execute
		name_pos = 0
		username_pos = [1, 0]
		last_login_pos = 2
		total_login_pos = 4

		@active_users.each do |row|
			@user_list << User.new({"username" => row[username_pos[0]],
				"name" => row[name_pos]})
		end

		@user_list.each do |user|
			@login_array.each do |row|
				if user.username == row[username_pos[1]]
					user.last_login = row[last_login_pos][0..9]
					user.total_logins = row[total_login_pos]
					user.status = "Active"
				end
				if user.status != "Active"
					user.status = "Active/No Login"
				end
			end
		end
	end

	def export
		date = Time.now.strftime("%Y%m")

		CSV.open("./reports/#{date}_report.csv", "wb") do |csv|
			csv << ['Username', 'Name', 'Last Login', 'Total Logins', 'Status']
			@user_list.each do |user|
				#puts "username: #{user.username}, name: #{user.irl_name}, last login: #{user.last_login}, total logins: #{user.total_logins}, status: #{user.status}"
				csv << [user.username, user.irl_name, user.last_login, user.total_logins, user.status]
			end
		end
		puts "Exported report as ./reports/#{date}_report.csv"
  	end
end