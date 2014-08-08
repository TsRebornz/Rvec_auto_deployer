require 'pathname' 

$LOAD_PATH <<  File.dirname(Pathname.new(File.expand_path(__FILE__)).realpath.to_s).to_s

require "Models/host_model"
require "Models/database_model"
require "Models/admin_cluster_model"
require "Models/app_server_model"
require "Models/reserve_cluster_model.rb"

class AutoDeployer

	def initialize config_data, topology_tree

	end

end
 