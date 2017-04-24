

tTemp = {}

function tTemp.new( config )
	local o = {}
	o.config = config
	setmetatable(o, { __index = tTemp })
	return o
end

function tTemp:init()
end

function tTemp:read()
	local status, temp, humid = dht.read( self.config.pin )
	if status == dht.OK then
		print( "DHT Temperature:" .. temp .. ";" .. "Humidity:" .. humid )
	elseif status == dht.ERROR_CHECKSUM then
	    print( "DHT Checksum error." )
	elseif status == dht.ERROR_TIMEOUT then
	    print( "DHT timed out." )
	end

	return temp, humid
end
