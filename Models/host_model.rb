
require 'pathname' 

$LOAD_PATH <<  File.dirname(Pathname.new(File.expand_path(__FILE__)).realpath.to_s).to_s

require "abstract_node_model"


class Host_model < Abstract_node_model
	MAIN = 1
	RESERVE = 2


	def initialize  topology_node_name , description, belongs, ip, mask, type #
		@topology_node_name = topology_node_name
		@description = description
		@belongs = belongs
		@os = "Windows"
		@ip = ip
		@mask = mask
		@type = type	
	end

	def to_s
		puts "topology_node_name #{@topology_node_name}\n"
		puts "description #{@description}\n"
		puts "belongs #{@belongs}\n"
		puts "ip #{@ip}\n" 
	    puts "mask #{@mask}\n"
		puts "type #{@type} \n"
		puts "ip #{@ip} \n" 
	end

end

#Debug
# topology_node_name = "SRV.EMS.JULEBIONO"
# description  = "Main Server"
# belongs = "EMS"
# ip = "10.43.123.43"
# mask = "255.255.255.0"
# type = 1
# h_model = Host_model.new(topology_node_name,description,belongs,ip,mask, type) 
# h_model.to_s



