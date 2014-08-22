require 'pathname' 

$LOAD_PATH <<  File.dirname(Pathname.new(File.expand_path(__FILE__)).realpath.to_s).to_s

require "topology_node"

class TopologyTree
	# tn - topology_node

	# Scheme это hash вида 
			hosts = {
						:main => { :model => nil, :database => nil, :app_serv => nil, :driver => nil },
						:reserve => {:model => nil, :database => nil, :app_serv => nil, :driver => nil },
						:arb => {:model => nil},
						:client1 => {:model => nil}
					}
			
}
    def initialize hash
    	hash.each_pair
	end

    def tree_size
    	return 5
	end

	def get_root
	
	end

	def create_node

	end

	def delete_node

	end
end