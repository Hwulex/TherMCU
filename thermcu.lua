dofile( "tservo.lua" )
dofile( "toled.lua" )
dofile( "ttemp.lua" )
dofile( "trotary.lua" )


TherMCU = {
	menuDep = 0
	menuPos = 0
	temp	= 0
	humid	= 0
	-- menu	= {{1,2,3}, {4,5,6}, {7,8,9}}
}

function TherMCU.new( config )
	local o = {}
	o.config = config
	setmetatable(o, { __index = TherMCU })

	o.servo		= tServo.new( o.config.servo )
	o.display	= tOled.new( o.config.display )
	o.led		= tLed.new( o.config.led )
	o.temp		= tTemp.new( o.config.temp )
	o.rotary	= tRotary.new( o.config.rotary )
	o.message	= tMessage.new( o.config.rotary )

	return o
end

function TherMCU:init()
	self.servo.init()
	self.display.init()
	self.temp.init()
	self.rotary.init()
	self.message.init()
end

function TherMCU:go()
	-- 60 second loop to read temp and update display
	-- tmr.alarm( 0, 60000, tmr.ALARM_AUTO, function()
	tmr.create():alarm( 60000, tmr.ALARM_AUTO, function()
		self.temp, self.humid = self.temp.read();
		if self.isLocked() == false then
			self.display.update( self.temp )
			self.menu = 0
		end
		self.message.send( { self.temp, self.humid } )
	end)

	-- tmr.alarm( 1, 1000, tmr.ALARM_AUTO, function()
	tmr.create():alarm( 1000, tmr.ALARM_AUTO, function()
		if 0 < self.menuTmr then
			self.display.lock()
			self.menuTmr = self.menuTmr - 1
		else
			self.display.unlock()
			self.display.update( self.temp )
		end
	end)
end

function TherMCU:instruct( topic, data )
	-- instruction from mqtt/pubnub
	-- instruction from rotary
		-- Basic turn left/right temp up/down
		-- push button enter menu
			-- Need to track menu depth and position

	if "temp" == topic then
		if data ~= self.temp then
			if min > data or max < data then
				self.display.update( "Set: " .. data )
			else
				degrees = (
					( config.servo.max - config.servo.min )
					/ ( config.temp.maxA - config.temp.minA )
				) * data
				self.servo.move( degrees )
				self.display.update( "Set: " .. data )
			end
		end
	end
end

function TherMCU:rotary( action )
	if 0 == action then
	-- push button
		self:instruct( "temp", self.menuPos )
		return
	elseif -1 == action then
	-- turn left
		if self.config.temp.min < self.menuPos then
			self.menuPos = self.menuPos -1
		end
		self.display.update( self.menuPos )
	elseif 1 == action then
	-- turn right
		-- If not at max temp, increase
		if self.config.temp.max > self.menuPos then
			self.menuPos = self.menuPos + 1
		end
		self.display.update( self.menuPos )
	else
		self.menuTmr = 0
		return
	end

	self.menuTmr = self.config.menu.timeout
end
