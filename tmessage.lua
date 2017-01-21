

tMessage = {}

function tMessage.new( config )
	local o = {}
	o.config = config
	setmetatable(o, { __index = tMessage })
	return o
end


function tMessage:init()
	-- init mqtt client with keepalive timer 120sec
	m = mqtt.Client( "clientid", 120, "user", "password" )
	m:connect( "192.168.11.118", 1883, 0, 1,
		function( client )
			print( "connected" )
		end,
		function( client, reason )
			print( "failed reason: "..reason )
		end
	)
end


function tMessage:send( data )
	m:publish( "/home/groundfloor/bedroom/master/temp", data, 0, 1, function(client)
		print("sent")
	end)
end
