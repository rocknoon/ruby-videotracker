require APP_LIB_PATH + '/clawer/ScanerList'


module VT
module Clawer
  class PortalScaner
    def initialize( domain, videoReg )
		@domain = domain;
		@scanerList	= ScanerList.new();
		@scanerList.push( 'www.' + domain );
		@scanerTP = ThreadPool.new(5);
		@scanerLogPath = APP_PATH + "/logs/scaner.log";
		@videoReg = videoReg;
    end
	
    #start the scaner thread			
    def start
	Thread.new do
	  loop do

	    if @scanerTP.full?
	      puts "scaner is fully busy!";		
	    else
	      @scanerTP.process do
	        url = @scanerList.fetch();
			if !url.nil?
				puts "begin to scan #{url}";
				_scan(url);
				log( @scanerLogPath , "begin to scan #{url} thread free working account #{@scanerTP.free_worker_count} working list #{@scanerList.size}" );
			end
		  end	
	     end
	     sleep(1);

      end
	end
    end
			
			
    private
    
    #scan one page.  get scanlist url and video urls			
    def _scan( url )
		html = get_html( url );
		html.scan(/<a\shref=('|")(http:\/\/(.*?)#@domain[^'|"]+)/) do | link |
			@scanerList.push(link[1]);
		end

		#get video portal
		#recordVideoPortal();
		html.scan(@videoReg) do | video |
		
			res = MysqlPool.CurrentThreadConn.query("
				SELECT * 
				FROM  `videos` 
				WHERE url =  '#{video}'
				LIMIT 0 , 30"
			);

			if res.num_rows === 0
				MysqlPool.CurrentThreadConn.query("
					INSERT INTO  `videotracker`.`videos` (
					`id` ,
					`url` ,
					`lock` ,
					`portal`, 
					`date_add` ,
					`date_upd`
					)
					VALUES (
					NULL ,  '#{video}',  0 , '#{@domain}' , '#{Time.now.strftime(DATATIME_FORMAT)}', NULL);");
			end	
		end
     
    end			
  end
	
end
end
