-- @todo polymorphic mqqt/pubnub classes

tMessage = {
	connect = false
}

function tMessage.new( config )
	local o = {}
	local m = {}
	o.config = config
	setmetatable(o, { __index = tMessage })
	return o
end

function tMessage:init()
	-- init mqtt client with keepalive timer 120sec
	self.m = mqtt.Client( creds.mqtt.client, self.config.poll, creds.mqtt.user, creds.mqtt.pass )
	self.m:connect( creds.mqtt.addr, creds.mqtt.port, self.config.scur, self.config.rcon,
		function( client )
			print( "MQTT connected" )

			self.m:subscribe( creds.mqtt.tpcRx, self.config.qoss, function( client )
				print( "MQTT subscribe success" )
			end)

			self.m:on( "message", receive )
		end,
		function( client, reason )
			print( "MQTT Failed reason: " .. reason )
			-- self.connect = false
		end
	)
end

function tMessage:send( data )
	-- if true == self.connect then
		self.m:publish( creds.mqtt.tpcTx, data, self.config.qosp, self.config.retn, function(client)
			print( "MQTT Tx: " .. creds.mqtt.tpcTx .. " - " .. data )
		end)
	-- end
end

function receive( client, topic, data )
	print( "MQTT Rx: " .. topic .. " - " .. data )
	if data ~= nil then
		print( data )
		app:instruct( topic, data );
	end
end
