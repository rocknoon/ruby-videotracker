#当前 APP 的Path
APP_PATH = '/home/www/workspace/videotracker';
APP_LIB_PATH = '/home/www/workspace/videotracker/lib';
APP_ERROR_LOG_PATH = APP_PATH + '/logs/error.log';


VT_THREAD_COUNT = 10;

#参与 clawer 的Portal 列表
VT_Portals = {
	:youku => "youku.com"
};

require APP_LIB_PATH + '/functions'
require APP_LIB_PATH + '/clawer'
#require APP_LIB_PATH + '/tracker'



VT::Clawer::Start();
#VT::Tracker::Start();
