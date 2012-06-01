

module VT
module Tracker

class TudouScaner
	
	include VT::Tracker::Scaner
	

	private 

	
	def _scanResource resource
	
		html = get_html(resource["url"]);
		videoId = resource["video_id_on_portal"];
		info = {:views => 0};
		
		if videoId.nil?
			html.scan(/iid\s+=\s+(\d+)?/).each do | value |
				videoId = value[0];
			end
		end
		
		#get view count;	
		html = get_html( "http://istat.tudou.com/itemSum.srv?iabcdefg=#{videoId}&uabcdefg=0" );
		html.scan(/playNum\":(\d+)/).each do |value|
			info[:views] = value[0];
		end
		
		return info;
	end
	
	

end

end
end
