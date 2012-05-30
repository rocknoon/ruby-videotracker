require 'net/http'

DatetimeFormat  = "%Y-%m-%d %H:%M:%S";



# get url body content.  
# if url is like www.domain.com  them transfer it to http://www.domain.com/
def get_html(url)

	if /^http:\/\//.match( url ) === nil
		url = 'http://' + url;	
	end 

	uri = URI(url)
	return Net::HTTP.get(uri);
end


# log a content
LogDatetimeFormat  = "%Y-%m-%d %H:%M:%S";
def log( file, content )
	#考虑只打开一次流
	txt_log = File.new(file,'a');
        txt_log.puts "#{Time.now.strftime(LogDatetimeFormat)} #{content}";
        txt_log.close;
end
