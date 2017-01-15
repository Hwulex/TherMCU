

tServo = {}

function tServo.new( config )
	local o = {}
	o.config = config
	setmetatable(o, { __index = tServo })
	return o
end


function tServo:init()
	gpio.mode( self.config.pin, gpio.OUTPUT )
	gpio.write( self.config.pin, gpio.LOW )
end
