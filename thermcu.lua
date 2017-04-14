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
			self.menuPos = self.temp
		end
		self.message.send( { self.temp, self.humid } )
	end)

	-- 1 second loop for menu handling and screen updating
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

-- Receive instructions from listener classes
function TherMCU:instruct( topic, data )
	-- instruction from mqtt/pubnub
	-- instruction from rotary
		-- Basic turn left/right temp up/down
		-- push button enter menu
			-- Need to track menu depth and position

	if "temp" == topic then
		-- Only continue if temp has selected different from current setting
		if data ~= self.temp then
			-- If setting outside user range, show current setting
			if min > data or max < data then
				self.display.update( "Set: " .. self.temp )
			else
				-- Calculate thermostat rotation
				degrees = (
					( config.temp.maxD - config.temp.minD )
					/ ( config.temp.maxA - config.temp.minA )
				) * data
				self.servo.move( degrees )
				self.display.update( "Set: " .. data )
			end
		end
	end
end

-- Rotary switch instruction interpretation
function TherMCU:rotary( action )
	if 0 == action then
	-- push button
		self:instruct( "temp", self.menuPos )
		return
	elseif -1 == action then
	-- turn left
		-- if selected temp is within defined range, update temp
		if self.config.temp.min < self.menuPos then
			self.menuPos = self.menuPos -1
		end
		-- Display selected temp. If selected temp outside range, show last
		-- valid temp that was within range as input has been ignored
		-- self.display.update( self.menuPos )
		self:instruct( "temp", self.menuPos )
	elseif 1 == action then
	-- turn right
		-- If not at max defined temp, increase
		if self.config.temp.max > self.menuPos then
			self.menuPos = self.menuPos + 1
		end
		self:instruct( "temp", self.menuPos )
	else
		-- Invalid event, reset timer to reset display
		self.menuTmr = 0
		return
	end

	-- Setting has been made, update screen for user defined time
	self.menuTmr = self.config.menu.timeout
end
