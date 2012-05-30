require APP_LIB_PATH + '/threadpool'
require APP_LIB_PATH + '/clawer/ScanerList'
require "mysql"


module VT
module Clawer
  class PortalScaner
	
    def initialize( domain )
	@my = Mysql::new("127.0.0.1", "root", "l2117839", "videotracker");
	@domain = domain;
	@scanerList	= ScanerList.new();
	@scanerList.push( 'www.' + domain );
	@scanerTP = ThreadPool.new(5);
        @scanerLogPath = APP_PATH + "/logs/scaner.log";
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
	          log( @scanerLogPath , "begin to scan #{url}" );
                end
              end	
	    end
	    sleep(1);

	  end
	end
	sleep(500);
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
      html.scan(/http:\/\/v.youku.com\/v_show\/id_.*?\.html/) do | video |
	res = @my.query("
	  SELECT * 
	  FROM  `videos` 
	  WHERE url =  '#{video}'
	  LIMIT 0 , 30"
        );

        if res.num_rows === 0
	  @my.query("
	    INSERT INTO  `videotracker`.`videos` (
	    `id` ,
            `url` ,
            `date_add` ,
	    `date_upd`
	    )
	    VALUES (
	     NULL ,  '#{video}',  '#{Time.now.strftime(DatetimeFormat)}', 
	     CURRENT_TIMESTAMP
            );");
        end	
      end
      

    end			
  end
	
end
end
