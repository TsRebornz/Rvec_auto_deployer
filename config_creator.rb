# require 'socket'
require 'resolv'

class ConfigCreator
	def create_config
			txt_block = ""
			txt_block << "{\n"
			txt_block << create_first_part
			txt_block << create_second_part
			txt_block << create_third_part
			txt_block << "}\n"
	end	
	
end


class ConfigStrategy
	def initialize(strategy)
    	singleton = class << self; self; end
    	singleton.send :include, strategy
  	end
end

module Database_part
	def create_config_part param1, param2
		puts param1 + " " + param2
		txt_block = ""
		txt_block << "\t\t \"database\" => [\n "
		txt_block << "\t\t { \n "
		txt_block << "\t\t\t \"dburl\" => \"jdbc:oracle:thin:@server_ip:database_port/database_name\", \n "
		txt_block << "\t\t\t \"user\" => \"database_user\" \n "
		txt_block << "\t\t\t \"password\" => \"database_password\" \n "
		txt_block << "\t\t } \n"
		txt_block << "\t ] } \n\n"
		return txt_block
	end
end

module Server_part
	def create_config_part param1
		txt_block = ""
		txt_block << "\t\t \"server\" => [\n "
		txt_block << "\t\t { \n "
		txt_block << "\t\t\t \"port\" => \"port\", \n "
		txt_block << "\t\t\t \"ntf_port\" => \"ntf_port\" \n "
		txt_block << "\t\t\t \"ip\" => \"ip_of_client\" \n "
		txt_block << "\t\t } \n"
		txt_block << "\t ] } \n\n"
	end
end

module Load_source_part
	def create_config_part param1, param2, param3
		txt_block = ""
		txt_block << "\t\t \"load_source\" => [\n "
		txt_block << "\t\t { \n "
		txt_block << "\t\t\t \"type\" => \"db\", \n "
		txt_block << "\t\t\t \"source\" => \"database\" \n "
		condition = false
		if condition
			txt_block << "\t\t\t \'repeat\' => \"repeat_param\" \n "
			txt_block << "\t\t\t \'timeout\' => \"timeout\" \n "
		end
		txt_block << "\t\t } \n"
		txt_block << "\t ] } \n\n"
	end
end

module Load_server_part
	def create_config_part
		txt_block = ""
		txt_block << "\t\t \"server\" => [\n "
		txt_block << "\t\t { \n "
		txt_block << "\t\t\t \"port\" => \"port\", \n "
		txt_block << "\t\t\t \"ntf_port\" => \"ntf_port\" \n "
		txt_block << "\t\t\t \"ip\" => \"ip_of_server\" \n "
		txt_block << "\t\t } \n"
		txt_block << "\t ] } \n\n"
	end
end

module Zookeeper_part
	def create_config_part
		txt_block = ""
		txt_block << "\t\t \"zookeeper\" => [\n "
		txt_block << "\t\t { \n "
		txt_block << "\t\t\t \"cluster\" => \"123\", \n "
		txt_block << "\t\t\t \"password\" => \"pasword\" \n "
		txt_block << "\t\t\t \"timeout\" => \"10000\" \n "
		txt_block << "\t\t\t \"addres\" => \"hostname1:zoo_port,hostname1:zoo_port,hostname1:zoo_port\" \n "
		txt_block << "\t\t } \n"
		txt_block << "\t ] } \n\n"
	end
end

class NetworkWorker
	def self.get_hostname_by_ip
		p Resolv.getname("192.168.3.221")
	end
end

class FileSaver
	def self.save_at_file script, path = "C:\\temp\\test_config.rb"
		begin
			File.open(path, 'w') do |f|
				f.write(script) 
				f.close 
			end	
		rescue Exception => e
			puts e.message
		end
		
	end
end

# script = ""
# database_part = ConfigStrategy.new(Database_part)
# database_part_script = database_part.create_config_part("1", "2")
# script << database_part_script
# server_part = ConfigStrategy.new(Server_part)
# server_part_script = server_part.create_config_part("1")
# script << server_part_script
# load_source_part = ConfigStrategy.new(Load_source_part)
# server_load_source_script = load_source_part.create_config_part("1","3","5")
# script << server_load_source_script
# FileSaver.save_at_file(script)
# puts NetworkWorker.get_hostname_by_ip
p Resolv.getaddress "google.com"