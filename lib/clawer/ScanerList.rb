module VT
	module Clawer
	
		class ScanerList
		
			
			
			def initialize()
				@list = Hash.new();
			end
		
		
			def push( url )
				
				if @list.key?(url) != true
					@list[url] = url;
				end
				
			end
			
			def fetch()
				node = @list.shift();
				return node[1];
			end
			
			
		
		end
	
	end

end
