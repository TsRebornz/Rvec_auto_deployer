

class TopologyNode
	attr_accessor :node_type
	attr_accessor :model # Ссылка на модель данных
	attr_accessor :parent_node
	attr_accessor :children_nodes

	def initialize type_node
		@type_node = type_node
		@children_nodes = []
	end

	def to_s
		puts "type_node #{@type_node}"
		puts "model #{@model}"
		puts "parent_node #{@parent_node}"
		puts "children_nodes #{@children_nodes}"
	end

	def add_children_node node
		@children_nodes << node if node
	end

end

# type_node = :model
# node = TopologyNode.new(type_node)
# node.model = "2341324"
# node.parent_node = "fadsf"
# node.add_children_node "fadsf"
# node.to_s
