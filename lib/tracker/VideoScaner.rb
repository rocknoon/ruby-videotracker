require APP_LIB_PATH + '/tracker/YoukuScaner'

module VT
module Tracker

class VideoScaner
	
	def self.create portal
		
		case portal
		when "youku.com"
		  return VT::Tracker::YoukuScaner.new();
		else
		  raise "No such portal";
		end
	
	end

end

end
end
