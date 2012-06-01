
module VT
module Tracker

module Scaner

	def initialize domain
		@portal   = domain;
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
	
	#this need to be override by children
	def _scanResource resource
	
		
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
