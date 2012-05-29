#视频爬虫
require APP_LIB_PATH + '/clawer/PortalScaner.rb'



module VT
	module Clawer
	
	
		def self.Start()
			
			if VT_Portals === nil
				raise "global var VT_Portals has not been specified";
			end
			
			VT_Portals.each do | key , portal |
				VT::Clawer::PortalScaner.new( portal ).start();
			end 
			
			
			
			
		end
		
		
		
	
	
	end
end
