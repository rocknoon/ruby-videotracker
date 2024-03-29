
module VT
module Tracker

class YoukuScaner

	include VT::Tracker::Scaner
	

	private 
	
	def _scanResource resource
	
		html = get_html(resource["url"]);
		videoId = resource["video_id_on_portal"];
		info = {:views => 0};
		
		if videoId.nil?
			html.scan(/videoId\s+=\s+['|"](\d+)?['|"]/).each do | value |
				videoId = value[0];
			end
		end
		
		#get view count;
		html = get_html( "http://v.youku.com/QVideo/~ajax/getVideoPlayInfo?__rt=1&__ro=&id=#{videoId}&type=vv" );
		html.scan(/:(\d+)/).each do |value|
			info[:views] = value[0];
		end
		
		return info;
	end
	

end

end
end
