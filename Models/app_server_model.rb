require 'pathname' 

$LOAD_PATH <<  File.dirname(Pathname.new(File.expand_path(__FILE__)).realpath.to_s).to_s

require "abstract_node_model"

class App_server_Model < Abstract_node_model

	
	def initialize topology_node_name , description, belongs, protocol, host, port, ntf_port
		@topology_node_name = topology_node_name
		@description = description
		@belongs = belongs
		@protocol = protocol
		@host = host
		@port = port
		@ntf_port = ntf_port
		@data_source = get_data_source_by_host(host)
	end

	def get_data_source_by_host host

		#TO_DO Write switch case implementation
		return "Hui"
	end

	def to_s
		puts "topology_node_name #{@topology_node_name}\n"
		puts "description #{@description}\n"
		puts "belongs #{@belongs}\n"
		puts "protocol #{@protocol}\n" 
		puts "host #{@host}"
		puts "port #{@port}\n" 
		puts "ntf_port #{@ntf_port}\n" 
	end

end


#Debug
# topology_node_name = "AppServer.EMS.JULEBIONO."
# description  = "Appserver for main host"
# belongs = "EMS"
# protocol = "drbfire:"
# host = "SRV.EMS.JULEBIONO"
# port = 2000
# ntf_port = 2001
# h_model = App_server_Model.new(topology_node_name, description, belongs, protocol, host, port, ntf_port) 
# h_model.to_s

