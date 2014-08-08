require 'pathname' 

$LOAD_PATH <<  File.dirname(Pathname.new(File.expand_path(__FILE__)).realpath.to_s).to_s

require "abstract_node_model"

class Database_model < Abstract_node_model

	
	def initialize topology_node_name , description, belongs, protocol, port, resource, user, password
		@topology_node_name = topology_node_name
		@description = description
		@belongs = belongs
		@protocol = protocol
		@port = port
		@host_ref = nil
		@resource = resource
		@user = user
		@password = password
	end

	def to_s
		user_host_ref = @host_ref.nil? ? "database_not_linked" : @host_ref 
		puts "topology_node_name #{@topology_node_name}\n"
		puts "description #{@description}\n"
		puts "belongs #{@belongs}\n"
		puts "protocol #{@protocol}\n" 
		puts "port #{@port}\n" 
	    puts "host_ref #{user_host_ref}\n"
		puts "resource #{@resource} \n"
		puts "user #{@user} \n" 
		puts "password #{@password} \n" 
	end

end


# #Debug
# topology_node_name = "DB.EMS.JULEBIONO."
# description  = "Database main"
# belongs = "EMS"
# protocol = "jdbc:oracle:thin:@"
# port = 1445
# resource = "dp01.something.ems"
# user = "rvec"
# password = "rvec"
# h_model = Database_model.new(topology_node_name,description,belongs,protocol,port, resource, user, password) 
# h_model.to_s

