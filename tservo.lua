

tServo = {
}

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

function tServo:move( degrees )
	position = self:_calcPos( degrees )

	-- drive the servo by generating high and low pulses
	tmr.create():alarm( 1000/self.config.frq, tmr.ALARM_AUTO, function()
		gpio.write( self.config.pin, gpio.HIGH )
		tmr.delay( position )
		gpio.write( self.config.pin, gpio.LOW )
	end)
	-- tmr.alarm( 2, 20, tmr.ALARM_AUTO, function() -- 50Hz
	-- end)
end

function tServo:_calcPos( degrees )
	-- Spectrum
	-- 400 = 0 deg
	-- 1400 = 90 deg
	-- 2400 = 180 deg

	position = self.config.min + ( ( ( self.config.max - self.config.min ) / 180 ) * degrees )
	return position
end
