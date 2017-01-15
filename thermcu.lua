dofile( "tservo.lua" )
dofile( "toled.lua" )
dofile( "ttemp.lua" )
dofile( "trotary.lua" )


TherMCU = {}

function TherMCU.new( config )
	local o = {}
	o.config = config
	setmetatable(o, { __index = TherMCU })

	o.servo		= tServo.new( o.config.servo )
	o.oled		= tOled.new( o.config.oled )
	o.temp		= tTemp.new( o.config.temp )
	o.rotary	= tRotary.new( o.config.rotary )

	return o
end


function TherMCU:init()
	self.servo.init()
	self.oled.init()
	self.temp.init()
	self.rotary.init()
end


function TherMCU:go()

end
