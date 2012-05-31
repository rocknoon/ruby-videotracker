#!/usr/local/ruby/bin/ruby

#当前 APP 的Path
APP_PATH = '/home/www/workspace/videotracker';
APP_LIB_PATH = APP_PATH + '/lib';
APP_ERROR_LOG_PATH = APP_PATH + '/logs/error.log';


# ===
# Mysql configuration
# ===
APP_MYSQL_HOST = '127.0.0.1';
APP_MYSQL_USER = 'root';
APP_MYSQL_PWD = 'l2117839';
APP_MYSQL_DB = 'videotracker';

#参与 clawer 的Portal 列表
VT_Portals = {
	:youku => { :domain => "youku.com" , :videoReg => /http:\/\/v.youku.com\/v_show\/id_.*?\.html/ }
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
