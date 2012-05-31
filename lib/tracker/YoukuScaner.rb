


module VT
module Tracker

class YoukuScaner

	def initialize
		@portal   = "youku.com";
		@scanerTP = ThreadPool.new(5);
		@scanerLogPath = APP_PATH + "/logs/video_scaner.log";
	end
	


	def start
		
		Thread.new do
			loop do
				if @scanerTP.full?
					puts "video scanner is fully busy!";		
				else
					@scanerTP.process do
						resource = _lockResource();
						
						if resource
							puts "begin to scan video #{resource["url"]}"
							info = _scanResource( resource );
							_recordResource( resource , info );
							_unlockResource( resource );
							log( @scanerLogPath , "scan video #{resource["url"]} the view is #{info[:views]} thread free working account #{@scanerTP.free_worker_count}" );
						end
					end	
				end
				sleep(1);
			end
		end		


	end

	private 

	def _lockResource
		resource = mysql_fetch_one( MysqlPool.CurrentThreadConn , "videos",  "where portal = '#{@portal}' and `lock` = 0 and ( date_upd < '#{time_today(true)}' or date_upd is null )" );
		if resource
			mysql_update( MysqlPool.CurrentThreadConn, "videos", { "lock" => 1 } , { "id" => resource["id"] } );
			return resource;
		end
	end
	
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
	
	def _recordResource resource , info
		mysql_insert( MysqlPool.CurrentThreadConn, "daily" , { "video_id" => resource["id"] , "views" => info[:views], "date_add" => Time.now.strftime("%Y-%m-%d") } );
	end
	
	def _unlockResource resource
		mysql_update( MysqlPool.CurrentThreadConn, "videos", { "lock" => 0, "date_upd" => Time.now.strftime(DATATIME_FORMAT) } , { "id" => resource["id"] } );
	end

end

end
end
