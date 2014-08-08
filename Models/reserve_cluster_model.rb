require 'pathname' 

$LOAD_PATH <<  File.dirname(Pathname.new(File.expand_path(__FILE__)).realpath.to_s).to_s

require "abstract_node_model"

class ReserveClusterModel < Abstract_node_model

	
	def initialize topology_node_name,description,belongs,array_of_nodes 
		@topology_node_name = topology_node_name
		@description = description
		@belongs = belongs
		@array_of_nodes = array_of_nodes
	end

	def to_s
		puts "topology_node_name #{@topology_node_name}\n"
		puts "description #{@description}\n"
		puts "belongs #{@belongs}\n"
		puts "array_of_nodes #{@array_of_nodes}\n"
	end

end


#Debug
# topology_node_name = "KRZ.EMS.JULEBIONO."
# description  = "Cluster of application servers"
# belongs = "EMS"
# array_of_nodes = ["SRV.MAIN.EMS.JULEBIONO","SRV.RESERVE.EMS.JULEBIONO"]
# h_model = ReserveClusterModel.new(topology_node_name,description,belongs,array_of_nodes) 
# h_model.to_s

