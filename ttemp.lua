

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
	local Humidity			= 0
	local HumidityDec		= 0
	local Temperature		= 0
	local TemperatureDec	= 0
	local Checksum			= 0
	local ChecksumTest		= 0
	local c					= 0

	bitStream = {}
	for j = 1, 40, 1 do
	     bitStream[j]=0
	end
	bitlength=0

	gpio.mode( self.config.pin, gpio.OUTPUT )
	gpio.write( self.config.pin, gpio.LOW )
	tmr.delay( 20000 )
	--Use Markus Gritsch trick to speed up read/write on GPIO
	gpio_read	= gpio.read
	gpio_write	= gpio.write

	gpio.mode(self.config.pin, gpio.INPUT)

	--bus will always let up eventually, don't bother with timeout
	while ( gpio_read( self.config.pin ) == 0 ) do end

	c = 0
	while ( gpio_read( self.config.pin ) == 1 and c < 100 ) do
		c = c + 1
	end

	--bus will always let up eventually, don't bother with timeout
	-- while ( gpio_read( pin ) == 0 ) do end
	--
	-- c = 0
	-- while ( gpio_read( pin ) == 1 and c < 100 ) do
	-- 	c = c + 1
	-- end

	--acquisition loop
	for j = 1, 40, 1 do
		while ( gpio_read( self.config.pin ) == 1 and bitlength < 10 ) do
				bitlength = bitlength + 1
		end
		bitStream[ j ] = bitlength
		bitlength = 0

		--bus will always let up eventually, don't bother with timeout
	     while ( gpio_read( self.config.pin ) == 0 ) do end
	end

	--DHT data acquired, processing it :-
	for i = 1, 8, 1 do
	     if ( bitStream[ i + 0 ] > 2 ) then
				Humidity = Humidity + 2 ^ ( 8 - i )
	     end
	-- end
	-- for i = 1, 8, 1 do
	     if ( bitStream[ i + 8 ] > 2 ) then
	          HumidityDec = HumidityDec + 2 ^ ( 8 - i )
	     end
	-- end
	-- for i = 1, 8, 1 do
		if ( bitStream[ i + 16 ] > 2 ) then
			Temperature = Temperature + 2 ^ ( 8 - i )
		end
	-- end
	-- for i = 1, 8, 1 do
		if ( bitStream[ i + 24 ] > 2 ) then
			TemperatureDec = TemperatureDec + 2 ^ ( 8 - i )
	    end
	-- end
	-- for i = 1, 8, 1 do
		if ( bitStream[ i + 32 ] > 2 ) then
			Checksum = Checksum + 2 ^ ( 8 - i )
		end
	end

	ChecksumTest = ( Humidity + HumidityDec + Temperature + TemperatureDec ) % 0xFF

	--print ("Temperature: "..Temperature.."."..TemperatureDec)
	--print ("Humidity: "..Humidity.."."..HumidityDec)
	--print ("ChecksumReceived: "..Checksum)
	--print ("ChecksumTest: "..ChecksumTest)

	return TemperatureDec, HumidityDec
end
