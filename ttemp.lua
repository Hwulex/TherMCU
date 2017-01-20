

tTemp = {}

function tTemp.new( config )
	local o = {}
	o.config = config
	setmetatable(o, { __index = tTemp })
	return o
end


function tTemp:init()
	print( self.config.pin )
end


function tTemp:getData()
	local status, temp, humi = dht.read( self.config.pin )
	if status == dht.OK then
		print( "DHT Temperature:" .. temp .. ";" .. "Humidity:" .. humi )
	elseif status == dht.ERROR_CHECKSUM then
	    print( "DHT Checksum error." )
	elseif status == dht.ERROR_TIMEOUT then
	    print( "DHT timed out." )
	end

	return temp, humi
end
