require 'pathname' 

$LOAD_PATH <<  File.dirname(Pathname.new(File.expand_path(__FILE__)).realpath.to_s).to_s

require "topology_node"
require  'Models/abstract_node_model'
require  'Models/admin_cluster_model'
require  'Models/app_server_model'
require  'Models/database_model'
require  'Models/host_model'


hosts = {
			:main => { :database => nil, :app_serv => nil, :driver => nil },
			:reserve => {:database => nil, :app_serv => nil, :driver => nil },
			:arb => nil,
			:client1 => nil
		}
enter_data = { :where => "ЭЛЕСИ"


}

class TopologyTree
	# tn - topology_node

	# Scheme это hash вида 
    def initialize hash 
    	hash.each_pair do |key, value|
    		create_node(key)
    		next if value.nil?
    		
		end
	end

	def fill_host hash
		hash.each_pair do |in_key, in_value|
			case in_key
			when :model
				in_value = Host_model.new(topology_node_name,description,belongs,ip,mask, type)
			when :database
				in_value = Database_model.new(topology_node_name,description,belongs,protocol,port, resource, user, password)
			when :app_serv
				in_value = App_server_Model.new(topology_node_name, description, belongs, protocol, host, port, ntf_port)
			when :driver
				in_value = App_server_Model.new(topology_node_name, description, belongs, protocol, host, port, ntf_port)
			else

			end
		end
	end


    def tree_size
    	return 5
	end

	def get_root
	
	end

	def create_node type_node
		node = TopologyNode.new(type_node)
		return node
	end

	def add_children_node

	end

	def delete_node

	end

	def show_tree

	end
end



