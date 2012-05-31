require APP_LIB_PATH + '/tracker/VideoScaner'


module VT
module Tracker


		def self.Start
			
			if VT_Portals === nil
				raise "global var VT_Portals has not been specified";
			end
			
			VT_Portals.each do | key , portal |
				VT::Tracker::VideoScaner.create( portal[:domain] ).start();
			end 
		
		end


end
end
