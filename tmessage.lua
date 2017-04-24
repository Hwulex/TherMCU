-- @todo polymorphic mqqt/pubnub classes

tMessage = {}

function tMessage.new( config )
	local o = {}
	o.config = config
	setmetatable(o, { __index = tMessage })
	return o
end

function tMessage:init()
	-- init mqtt client with keepalive timer 120sec
	m = mqtt.Client( self.config.clnt, self.config.poll, self.config.user, self.config.pass )
	m:connect( self.config.addr, self.config.port, self.config.scur, self.config.rcon,
		function( client )
			print( "MQTT connected" )
		end,
		function( client, reason )
			print( "MQTT Failed reason: " .. reason )
		end
	)

	m:subscribe( "/topic", self.config.qoss, function( client )
		print( "MQTT subscribe success" )
	end)

	m:on( "message", receive )
end

function tMessage:send( data )
	m:publish( "/home/groundfloor/bedroom/master/temp", data, self.config.qosp, self.config.retn, function(client)
		print( "MQTT Tx" .. data )
	end)
end

function tMessage:receive( client, topic, data )
	print( "MQTT Rx: " .. topic .. ":" )
	if data ~= nil then
		print( data )
		app:instruct( topic, data );
	end
end
