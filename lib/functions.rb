require 'net/http'
require "mysql"

# == Global Constant
DATATIME_FORMAT  = "%Y-%m-%d %H:%M:%S";



# ===get url body content.  
# if url is like www.domain.com  them transfer it to http://www.domain.com/
def get_html(url)
	if /^http:\/\//.match( url ) === nil
		url = 'http://' + url;	
	end 
	uri = URI(url)
	return Net::HTTP.get(uri);
end


# ================
# time
# ================

#
def time_today str = false
	
	today = Time.new(
		Time.now.year,
		Time.now.month,
		Time.now.day,
		0,0,0);
	if  str
		return today.strftime(DATATIME_FORMAT);
	end
	
	return today.to_i;
	
end


# ================
# mysql adapter 
# mysql manipulation
# ================

def mysql_adapter host, user, password, db
	return Mysql::new(host, user, password, db);
end

def mysql_query adapter, query
	begin
		res = adapter.query(query);
		return res;
	rescue Exception => ex
		raise ex.message + "sql : #{query}";
	end
end

def mysql_exec adapter, query
	begin
		adapter.query(query);
	rescue Exception => ex
		raise ex.message + "sql : #{query}";
	end
end

#conditions String where id = 1
def mysql_fetch_one adapter, table, condition
	
	sql = "select * from `#{table}` #{condition} limit 0,1";
	res = mysql_query( adapter, sql);
	
	if res.num_rows === 0
		return nil;
	end
	
	res.each_hash do | line |
		return line;
	end
	
end

def mysql_fetch_all adapter, table, condition , pageNo = nil, pageSize = nil
	
	if !pageNo.nil? && !pageSize.nil?
		limit_a = ( pageNo - 1 ) * pageSize;
		limit_b = pageSize;
		limit = " limit #{limit_a},#{limit_b}";
	end
	
	sql = "select * from `#{table}` #{condition}";
	
	if !limit.nil?
		sql << limit;
	end
	
	res = mysql_query(adapter , sql);
	
	rtn = [];
	res.each_hash do | line |
		rtn << line;
	end
	
	return rtn;
	
end

def mysql_update adapter, table, data, condition 

	set_sql = "";
	where_sql = " 1 = 1 ";
	
	condition.each do | key, value |
		where_sql << "AND `#{key}` = '#{value}' ";
	end
	
	data.each do | key, value |
		set_sql << "`#{key}` = '#{value}',";
	end
	
	set_sql = set_sql.slice( 0, set_sql.length-1 );
	
	sql = "UPDATE `#{table}` SET #{set_sql} WHERE #{where_sql}"
	
	mysql_exec( adapter , sql );
	
end

def mysql_insert adapter, table, data

	colum_sql = "id";
	value_sql = "NULL";
	
	data.each do | key, value |
		colum_sql << ",`#{key}`";
		value_sql << ",'#{value}'";
	end
	
	sql = "INSERT INTO #{table}  (#{colum_sql}) VALUES (#{value_sql});";
	mysql_exec( adapter , sql );
	
	return adapter.insert_id;
	
end




# ================
# log
# ================
LOG_IOS = {}
def log( file, content )
	#考虑只打开一次流
	if LOG_IOS[file].nil?
		LOG_IOS[file] = File.new(file,'a');
	end
        LOG_IOS[file].puts "#{Time.now.strftime(DATATIME_FORMAT)} #{content}";
end

# close the log file IO
def log_close( file = nil )
	if !file.nil?
		LOG_IOS[file].close;
		LOG_IOS.delete(file);
	else
		LOG_IOS.each do | key, io |
			LOG_IOS[key].close;
			LOG_IOS.delete(key);
		end
	end
end
