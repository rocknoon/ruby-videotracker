require 'net/http'

def get_html( url )
	return Net::HTTP.get(url, '/');
end
