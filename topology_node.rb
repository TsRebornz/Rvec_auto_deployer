

class TopologyNode
	attr_accessor :node_type
	attr_accessor :type
	attr_accessor :model # Ссылка на модель данных
	attr_accessor :parent_node
	attr_accessor :children_nodes

	def initialize parent_node
		
	end
end