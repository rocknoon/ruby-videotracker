#!/usr/local/ruby/bin/ruby
require 'pathname'


#当前 APP 的Path
APP_PATH = (Pathname.new(File.dirname(__FILE__)).realpath).to_s;
APP_LIB_PATH = APP_PATH + '/lib';
APP_ERROR_LOG_PATH = APP_PATH + '/logs/error.log';


# ===
# Mysql configuration
# ===
APP_MYSQL_HOST = '127.0.0.1';
APP_MYSQL_USER = 'weflex_dingen';
APP_MYSQL_PWD = 'dingen';
APP_MYSQL_DB = 'videotracker';

#参与 clawer 的Portal 列表
VT_Portals = {
	:youku => { :domain => "youku.com" , :videoReg => /http:\/\/v.youku.com\/v_show\/id_.*?\.html/ },
	:tudou => { :domain => "tudou.com" , :videoReg => /http:\/\/www.tudou.com\/programs\/view\/[^\/'"]+/ }
};

require APP_LIB_PATH + '/functions'
require APP_LIB_PATH + '/mysqlpool'
require APP_LIB_PATH + '/threadpool'
require APP_LIB_PATH + '/clawer'
require APP_LIB_PATH + '/tracker'


begin
	VT::Clawer::Start();
	VT::Tracker::Start();
rescue Exception => ex
	log( APP_ERROR_LOG_PATH , ex.message + "\n" +  ex.backtrace.join("\n"));
	raise ex;
end


loop{
	sleep(5);
}


#close log io
log_close;
MysqlPool.close;
