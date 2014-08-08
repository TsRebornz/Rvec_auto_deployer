require 'pathname' 

$LOAD_PATH <<  File.dirname(Pathname.new(File.expand_path(__FILE__)).realpath.to_s).to_s

require "abstract_node_model"

class AdminClusterModel < Abstract_node_model
	
	def initialize topology_node_name , description, belongs, array_nodes , client_port, leader_port, election_port, tick_time, conf_file_path = "C:/ProgramPark/zookeeper/conf/zoo.cfg" , data_dir = "C:/ProgramPark/zookeeper/data"
		@topology_node_name = topology_node_name
		@description = description
		@belongs = belongs
		@array_nodes = array_nodes
		@client_port = client_port
		@leader_port = leader_port
		@election_port = election_port
		@tick_time = tick_time
		@conf_file_path = conf_file_path
		@data_dir = data_dir
	end

	def to_s
		puts "topology_node_name #{@topology_node_name}\n"
		puts "description #{@description}\n"
		puts "belongs #{@belongs}\n"
		puts "array_nodes #{@array_nodes}\n" 
		puts "client_port #{client_port}"
		puts "leader_port #{@leader_port}\n" 
	    puts "election_port #{election_port}\n"
	    puts "tick_time #{tick_time}\n"
	    puts "conf_file_path #{conf_file_path}\n"
	    puts "data_dir #{data_dir}\n"
	end

end


# #Debug
# topology_node_name = "KAD.ZUK.EMS.JULEBIONO."
# description  = "Administrate cluster"
# belongs = "EMS"
# array_nodes = ["SRV.EMS.MAIN.JULEBIONO","SRV.EMS.RESERVE.JULEBIONO","SRV.EMS.ARB.JULEBIONO"]
# client_port = 3000
# leader_port = 3001
# election_port = 3002
# tick_time = 2000
# h_model = AdminClusterModel.new(topology_node_name,description,belongs,array_nodes,client_port, leader_port, election_port, tick_time) 
# h_model.to_s

