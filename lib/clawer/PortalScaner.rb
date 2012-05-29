require APP_LIB_PATH + '/clawer/ScanerList'

module VT
	module Clawer
	
		class PortalScaner
			
			
		
			def initialize( domain )
				@domain = domain;
				@scanerList	= ScanerList.new();
				@scanerList.push(domain);
			end
			
			
			def start()
				node = @scanerList.fetch();
				_scan(node);
			end
			
			
			private
			
			def _scan( url )
				
				html = get_html( url );
				puts html;
				
				#get items
				#list.push( item );
				#get video portal
				#recordVideoPortal();
			end
			
		end
	
	end

end
