# Входные параметры
where = 		"ЭЛЕСИ" # "МЕТРО", "ОФИС"
object_name = 	"СПРТ" # Название станции , линии , объекта
metro_service = "ЭМС"
ip_hash = 		{
			    "АРБ" => "192.168.3.43",
	            "АРМ" => "192.168.3.6",
	            "ОСН" => "192.168.3.41",
	            "РЕЗ" => "192.168.3.42"
				}

data_base_hash = {
				"БД.ОСН" => { :name => "dp01.bl.ems", :user => "rvec", :password => "rvec" },
				"БД.РЕЗ" => { :name => "dp01r.bl.ems", :user => "rvec", :password => "rvec" }
				}
hash_reduction = { 
				"АРБ" => "Арбитр",
				"АРМ" => "АРМ",
				"ОСН" => "Основной сервер",
				"РЕЗ" => "Резервный сервер",
				"АРМ.ДСП" => "Сервер приложений АРМ (ЭЛЕСИ)",
				"ОСН.ДСП" => "Сервер приложений основного сервера",
				"РЕЗ.ДСП" => "Сервер приложений резервного сервера",
				"ДРВ.ОСН" => "Сервер приложений Драйвер ОРС основной",
				"ДРВ.РЕЗ" => "Сервер приложений Драйвер ОРС резервный",
				"БД.ОСН" => "БД Основная",
				"БД.РЕЗ" => "БД Резервная",
				"КРЗ" => "Кластер резервирования серверов приложений",
				"КАД" => "Кластер администрирования"
		}

ports_hash_value = {
				:serv => {:port => 2000, :ntf_port => 2001},
				
				:driver => {:port => 2002,:ntf_port => 2003},
				
				:database =>{:port => 1521},

				:cluster => {:client_port => 3000,:leader_port => 3001,:election_port => 3002}
		 			}
# ip_hash = {
	#			  "АРБ" => "192.168.3.43",
	#             "АРМ" => "192.168.3.6",
	#             "ОСН" => "192.168.3.41",
	#             "РЕЗ" => "192.168.3.42"
	# }

	# data_base_hash = {
	# 	"БД.ОСН" => "dp01.bl.ems",
	# 	"БД.РЕЗ" => "dp01r.bl.ems",
	# }			

class Topology_Creator

	def initialize where, metro_service, ip_hash, data_base_hash , object_name, hash_reduction, ports_hash_value
		@where = where
		@metro_service = metro_service
		@ip_hash = ip_hash
		@object_name = object_name
		@script = ""
		@nodes_name_hash = Hash.new
		@data_base_hash = data_base_hash 
		@hash_reduction = hash_reduction 
		@ports_hash_value = ports_hash_value
		create_topology
	end
	
	def create_host node_name = "АРБ"
		host_node_name = "СРВ.#{@where}.#{node_name}.ДСП.#{@object_name}.#{@metro_service}"
		@nodes_name_hash[node_name] = host_node_name
		txt_block = ""
		txt_block << "Host.recreate \"#{host_node_name}\" do \n"
		txt_block << "\t description \"Хост #{@hash_reduction[node_name]}\"\n"
		txt_block << "\t belongs_to :#{@metro_service}\n"
		txt_block << "\t os :Windows\n"
		txt_block << "\t interface 1 do \n"
		txt_block << "\t\t ip \"#{@ip_hash[node_name]}\"\n"
		txt_block << "\t\t mask \"255.255.255.0\" \n"
		txt_block << "\tend\n"
		txt_block << "end\n"
		txt_block << "\n"
		txt_block
	end

	def create_database node_name = "БД.ОСН"
		host_node_name = "БДН.#{@where}.#{node_name}.ДСП.#{@object_name}.#{@metro_service}"
		@nodes_name_hash[node_name] = host_node_name
		host_name = node_name.split('.').last
		port_hash = get_ports_by_node_name(node_name)
		#Debug
		#puts "port_hash #{port_hash}"
		db_hash = @data_base_hash[node_name]
		txt_block = ""
		txt_block << "Database.recreate \"#{host_node_name}\" do \n"
		txt_block << "\t description \"#{@hash_reduction[node_name]}\"\n"
		txt_block << "\t belongs_to :#{@metro_service}\n"
		txt_block << "\t protocol \"jdbc:oracle:thin:@\"\n"
		txt_block << "\t host \"#{@nodes_name_hash[host_name]}\"\n"
		txt_block << "\t port \"#{port_hash[:port]}\" \n"
		txt_block << "\t resource \"#{db_hash[:name]}\"\n"
		txt_block << "\t user \"#{db_hash[:user]}\" \n"
		txt_block << "\t password \"#{db_hash[:password]}\" \n"
		txt_block << "end\n"
		txt_block << "\n"
		txt_block
	end

	def create_reserve_cluster node_name = "КРЗ", nodes_array = ["ОСН", "РЕЗ"]
		nodes_string = ""
		nodes_array.each { |host_name| nodes_string << "\""+@nodes_name_hash[host_name]+"\""+(( host_name == nodes_array.last) ? "" : "," )  }
		host_node_name = "КРЗ.#{node_name}.#{@where}.ДСП.#{@object_name}.#{@metro_service}"
		@nodes_name_hash[node_name] = host_node_name
		txt_block = ""
		txt_block << "ReserveCluster.recreate \"#{host_node_name}\" do \n"
		txt_block << "\t description \"#{@hash_reduction[node_name]}\"\n"
		txt_block << "\t belongs_to :#{@metro_service}\n"
		txt_block << "\t nodes " + nodes_string + "\n"
		txt_block << "end\n"
		txt_block << "\n"
		txt_block
	end

	def create_admin_cluster node_name = "КАД", nodes_of_cluster = ["ОСН","РЕЗ","АРБ"]
		host_node_name = "#{node_name}.ЗУК.#{@where}.ДСП.#{@object_name}.#{@metro_service}"
		@nodes_name_hash[node_name] = host_node_name
		port_hash = get_ports_by_node_name(node_name)
		count = 1
		txt_block = ""
		txt_block << "AdminCluster.recreate :ZooKeeper, \"#{host_node_name}\" do \n"
		txt_block << "\t description \"#{@hash_reduction[node_name]}\"\n"
		txt_block << "\t belongs_to :#{@metro_service}\n"
		nodes_of_cluster.each do |cur_node|
			txt_block << "\t node \"node#{count}\" do \n"
			txt_block << "\t\t description \"Узел ZooKeeper #{cur_node}\" \n"
			txt_block << "\t\t number #{count} \n"
			txt_block << "\t\t host \"#{@nodes_name_hash[cur_node]}\"\n"
			txt_block << "\t\t client_port #{port_hash[:client_port]}\n"
			txt_block << "\t\t leader_port #{port_hash[:leader_port]}\n"
			txt_block << "\t\t election_port #{port_hash[:election_port]}\n"
			txt_block << "\t\t tick_time 2000 \n"
			txt_block << "\t\t conf_file_path \"C:/ProgramPark/zookeeper/conf/zoo.cfg\" \n"
			txt_block << "\t\t data_dir \"C:/ProgramPark/zookeeper/data\" \n"
			txt_block << "\t end \n"
			count += 1
		end
		txt_block << "end \n"
	end

	def create_app_server node_name = "АРМ.ДСП"
		host_node_name = "СПР.#{@where}.#{node_name}.#{@object_name}.#{@metro_service}"
		@nodes_name_hash[node_name] = host_node_name
		port_hash = get_ports_by_node_name(node_name)
		#Debug
		#puts "port_hash #{port_hash}"
		nodes_app_hash = get_hash_appserv_by_node_name(node_name)
		txt_block = ""
		txt_block << "ApplicationServer.recreate \"#{host_node_name}\" do \n"
		txt_block << "\t description \"#{@hash_reduction[node_name]}\"\n"
		txt_block << "\t belongs_to :#{@metro_service}\n"
		txt_block << "\t protocol \"drbfire:\"\n"
		txt_block << "\t host \"#{nodes_app_hash[:host]}\"\n"
		txt_block << "\t port \"#{port_hash[:port]}\" \n"
		txt_block << "\t ntf_port \"#{port_hash[:ntf_port]}\" \n"
		txt_block << "\t data_source \"#{nodes_app_hash[:data_source]}\" \n"
		txt_block << "end\n"
		txt_block << "\n"
		txt_block
	end

	def get_ports_by_node_name node_name
		case node_name
		when "АРМ.ДСП"
			return @ports_hash_value[:serv]
		when "ДРВ.ОСН"
			return @ports_hash_value[:driver]
		when "ДРВ.РЕЗ"
			return @ports_hash_value[:driver]
		when "ОСН.ДСП"
			return @ports_hash_value[:serv]
		when "РЕЗ.ДСП"
			return @ports_hash_value[:serv]
		when "БД.ОСН" 
			return @ports_hash_value[:database]
		when "БД.РЕЗ" 
			return @ports_hash_value[:database]
		when "КАД" 
			return @ports_hash_value[:cluster]
		end

	end

	def get_hash_appserv_by_node_name node_name
		app_hash = Hash.new
		app_hash = {:host => "", :data_source => "" }
		case node_name
		when "АРМ.ДСП"
			app_hash[:host] = @nodes_name_hash["АРМ"]
			app_hash[:data_source] = @nodes_name_hash["КРЗ"]
		when "ДРВ.ОСН" 
			app_hash[:host] = @nodes_name_hash["ОСН"]
			app_hash[:data_source] = @nodes_name_hash["ОСН"]
		when "ДРВ.РЕЗ" 
			app_hash[:host] = @nodes_name_hash["РЕЗ"]
			app_hash[:data_source] = @nodes_name_hash["РЕЗ"]
		when "ОСН.ДСП"
			app_hash[:host] = @nodes_name_hash["ОСН"]
			app_hash[:data_source] = @nodes_name_hash["БД.ОСН"]
		when "РЕЗ.ДСП" 
			app_hash[:host] = @nodes_name_hash["РЕЗ"]
			app_hash[:data_source] = @nodes_name_hash["БД.РЕЗ"]
		end
		app_hash
	end

	

	def create_topology
		script = ""
		script << create_host("АРБ")
		script << create_host("ОСН")
		script << create_host("РЕЗ")
		script << create_host("АРМ")
		script << create_database("БД.ОСН")
		script << create_database("БД.РЕЗ")
		script << create_reserve_cluster("КРЗ")
		script << create_app_server("АРМ.ДСП")
		script << create_app_server("ДРВ.ОСН")
		script << create_app_server("ДРВ.РЕЗ")
		script << create_app_server("РЕЗ.ДСП")
		script << create_app_server("РЕЗ.ДСП")
		script << create_admin_cluster("КАД",["ОСН","РЕЗ","АРБ"])
		save_at_file(script)
	end

	def save_at_file script
		path = "C:\\temp\\test.rb"
		File.open(path, 'w') {|f| f.write(script) }
	end
end

topology_create = Topology_Creator.new(where, metro_service, ip_hash, data_base_hash, object_name, hash_reduction, ports_hash_value)
