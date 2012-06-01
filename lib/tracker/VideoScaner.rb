require APP_LIB_PATH + '/tracker/ModuleScaner'
require APP_LIB_PATH + '/tracker/YoukuScaner'
require APP_LIB_PATH + '/tracker/TudouScaner'

module VT
module Tracker

class VideoScaner
	
	def self.create portal
		
		case portal
		when "youku.com"
		  return VT::Tracker::YoukuScaner.new("youku.com");
		when "tudou.com"
		  return VT::Tracker::TudouScaner.new("tudou.com");
		else
		  raise "No such portal";
		end
	
	end

end

end
end
