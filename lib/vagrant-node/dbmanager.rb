require 'sqlite3'

module Vagrant
	module Node
		module DB
			class DBManager
				
				def initialize(data_dir)
					@db=check_database(data_dir)			
					puts @db		
				end
				
#				def add_node(node_name,node_address,node_port,dnsformat)
#					
#					if (!portvalid?(node_port))		
#						raise "Node port must be above 1023"
#					end
#					
#					
#					if (!namevalid?(node_name))
#						raise "Node name Invalid (Spectial characters allowed: '_' and '-')." 
#					end
#					
#					if (dnsformat && !dnsvalid?(node_address)) || 
#						(!dnsformat && !ipvalid?(node_address))						
#					
#						raise "Invalid ip or dns address."
#						 
#					end				
#														
#					
#					sql="INSERT INTO #{TABLE_NAME} VALUES ( ? , ? , ?)"
#					@db.execute(sql,node_name,node_address,node_port)
#					
#				end
#				
#				def update_node(node_name,node_address,node_port,dnsformat)
#					
#					if (!portvalid?(node_port))						
#					
#						raise "Node port must be above 1023"
#						 
#					end
#					
#					if (dnsformat && !dnsvalid?(node_address)) || 
#						(!dnsformat && !ipvalid?(node_address))						
#					
#						raise "Invalid ip or dns address."
#						 
#					end			
#					
#					sql="UPDATE #{TABLE_NAME} SET #{NODE_ADDRESS_COLUMN} = ?,#{NODE_PORT_COLUMN} = ?  WHERE #{NODE_NAME_COLUMN}= ?"
#					@db.execute(sql,node_address,node_port,node_name)
#					
#				end
#				
#
#				
#				
#				def remove_node(node_name)
#					sql="DELETE FROM #{TABLE_NAME} WHERE #{NODE_NAME_COLUMN}=?"
#					@db.execute(sql,node_name)
#				end
#				
#				def remove_nodes
#					sql="DELETE FROM #{TABLE_NAME}"
#					@db.execute(sql)
#				end
#
#				
#				def get_node_names
#					sql="SELECT #{NODE_NAME_COLUMN} FROM #{TABLE_NAME}"
#					return @db.execute(sql);
#				end				
#				
#				def get_nodes				
#					sql="SELECT * FROM #{TABLE_NAME}"
#					rows=@db.execute(sql);
#					nodes = []
#					rows.each do |row|
#						node = {}
#						node[:name]=row[0]
#						node[:address]=row[1]
#						node[:port]=row[2]
#						nodes << node
#					end
#
#					return nodes
#				end
#				
#				def get_node(node_name)
#					sql="SELECT * FROM #{TABLE_NAME} WHERE #{NODE_NAME_COLUMN}=?"
#					raise "Node not found" if (nodear=@db.execute(sql,node_name)).empty?
#					node = {}
#					node[:name]=nodear[0][0]
#					node[:address]=nodear[0][1]
#					node[:port]=nodear[0][2]
#					return node
#				end
				
				private
			
				BACKUP_TABLE_NAME='node_table'
				DATE_COLUMN = 'date'
				VM_COLUMN = 'vm_name'
				BACKUP_STATUS = 'backup_status'
				
				def check_database(data_dir)					
					#Creates and/or open the database
					db = SQLite3::Database.new( data_dir.to_str )
									
					if db.execute("SELECT name FROM sqlite_master 
											 WHERE type='table' AND name='#{BACKUP_TABLE_NAME}';").length==0						
						db.execute( "create table '#{BACKUP_TABLE_NAME}' (#{NODE_NAME_COLUMN} TEXT NOT NULLL, 
												 																#{VM_COLUMN} TEXT PRIMARY_KEY,
												 																#{BACKUP_STATUS} TEXT NOT NULL);" )
					end
					return db
				end
		
				def ipvalid?(node_address)
						
						ipreg= '^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$'
						
						
						ipregex = Regexp.new(ipreg)
						

						if (node_address =~ ipregex) 
							return true
						end
						
						return false 
						
				end
				
				def dnsvalid?(node_address)
						
						
						hostreg='^(([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\-]*[a-zA-Z0-9])\.)*([A-Za-z0-9]|[A-Za-z0-9][A-Za-z0-9\-]*[A-Za-z0-9])$'
						
						
						hregex = Regexp.new(hostreg)

						if (node_address =~ hregex)
							return true
						end
						
						return false 
						
				end
				
						
				def namevalid?(node_name)
					#only allowing '_' and '-'
					namereg = '^[a-z0-9_-]*$'
					nameregex = Regexp.new(namereg)
					if (node_name =~nameregex)
						return true
					end
						return false
						
				end
				
				def portvalid?(node_port)
					if (node_port>=1024)
						return true
					end
					return false
				end
						
			end
		end
	end
end
