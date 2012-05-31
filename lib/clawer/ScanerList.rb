# scan urls 的列表维护类

module VT
module Clawer
	class ScanerList
		
		Size = 40;
			
		def initialize()
			@list = Hash.new();
		end

		def full?
			if @list.length >= Size
				return true;			
			else			
				return false;
			end 
		end
		
		
		def push( url )	
			if @list.key?(url) != true && self.full? === false
				@list[url] = url;
			end
		end

		def size
			@list.size;
		end
			
		def fetch
			node = @list.shift();
  			if !node.nil?
			  return node[1];
			end
		end
			
			
		
	end
	
end
end
