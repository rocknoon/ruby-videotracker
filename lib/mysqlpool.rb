

# ================
# mysql  
# mysql 链接的维护  每一个线程单独维护一个 mysql 连接
# ================


class MysqlPool
	
	Pool = {};

	def self.CurrentThreadConn
		tId = Thread.current.object_id;
		if Pool[tId].nil?
			Pool[tId] = mysql_adapter( APP_MYSQL_HOST , APP_MYSQL_USER, APP_MYSQL_PWD, APP_MYSQL_DB);
		end
		return Pool[tId];
	end
	
	def self.Close
		
	end

end
